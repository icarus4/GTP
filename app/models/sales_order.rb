# == Schema Information
#
# Table name: sales_orders
#
#  id                     :integer          not null, primary key
#  company_id             :integer
#  partner_id             :integer
#  bill_to_location_id    :integer
#  ship_to_location_id    :integer
#  ship_from_location_id  :integer
#  assignee_id            :integer
#  payment_method_id      :integer
#  status                 :integer          default("draft"), not null
#  invoice_status         :integer          default("uninvoiced"), not null
#  packing_status         :integer          default(0), not null
#  shipment_status        :integer          default("unshipped"), not null
#  payment_status         :integer          default("unpaid"), not null
#  tax_treatment          :integer          default("exclusive"), not null
#  line_items_count       :integer          default(0), not null
#  total_units            :integer          default(0), not null
#  subtotal               :decimal(12, 2)
#  total_tax              :decimal(12, 2)
#  total_amount           :decimal(12, 2)
#  issued_on              :date
#  expected_delivery_date :date
#  order_number           :string
#  email                  :string
#  notes                  :text
#  extra_info             :jsonb
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  phone                  :string
#
# Indexes
#
#  index_sales_orders_on_company_id_and_partner_id  (company_id,partner_id)
#  index_sales_orders_on_order_number               (order_number)
#

class SalesOrder < ApplicationRecord
  include Taxable
  include AASM

  after_initialize :setup_defaults
  after_save :update_status!, if: :shipment_status_changed?

  belongs_to :company
  belongs_to :partner
  belongs_to :bill_to_location, class_name: 'Location', foreign_key: :bill_to_location_id
  belongs_to :ship_to_location, class_name: 'Location', foreign_key: :ship_to_location_id
  belongs_to :ship_from_location, class_name: 'Location', foreign_key: :ship_from_location_id

  has_many :line_items
  has_many :line_item_commitments, through: :line_items
  has_many :shipments

  validates :status,
            :company_id,
            :bill_to_location_id,
            :ship_to_location_id,
            :ship_from_location_id, presence: true
  validates :order_number, presence: true, uniqueness: { scope: :company_id }

  enum status: { draft: 0, active: 1, finalized: 2, fulfilled: 3, void: 4, deleted: 5 }
  enum invoice_status:  { uninvoiced: 0, partial: 1, invoiced: 2 }, _prefix: :invoice_status_is
  enum shipment_status: { unshipped: 0,  partial: 1, shipped: 2 },  _prefix: :shipment_status_is
  enum payment_status:  { unpaid: 0,     partial: 1, paid: 2 },     _prefix: :payment_status_is

  auto_strip_attributes :email, :phone, :notes

  aasm column: :status do
    state :draft, initial: true
    state :active
    state :finalized
    state :fulfilled
    state :void
    state :deleted

    event :approve do
      transitions from: :draft, to: :active
    end

    event :finalize do
      transitions from: :active, to: :finalized
    end

    event :delete do
      transitions from: :draft,  to: :deleted, after: :rollback_stocks!
      transitions from: :active, to: :deleted, after: :rollback_stocks!
    end

    event :void do
      transitions from: :finalized, to: :void, after: :rollback_stocks!
      transitions from: :fulfilled, to: :void, after: :rollback_stocks!
    end
  end

  def self.next_number(company_id)
    where(company_id: company_id).maximum(:order_number).try(:next) || 'SO0001'
  end

  # TODO: 檢討哪些地方call到這個method，思考這個method可以透過callback自動化被執行嗎?
  def update_status!
    # TODO: Refine
    if finalized? && shipment_status_is_shipped?
      fulfilled!
    elsif fulfilled? && !shipment_status_is_shipped?
      finalized!
    end
  end

  # TODO: shipment status should be updated automatically.
  def update_shipment_status!
    if line_items.shipment_status_is_partial.exists? # 有partial shipped line_items
      # 至少有一個 line_item 為 partial => partial
      shipment_status_is_partial!
    elsif !line_items.shipment_status_is_shipped.exists? # 沒有shipped line_items
      # 沒有任何partial && 沒有shipped line_items => 全部 line_items unshipped => unshipped
      shipment_status_is_unshipped!
    elsif !line_items.shipment_status_is_unshipped.exists? # 沒有unshipped line_items
      # 沒有任何partial && 部分或全部 shipped && 沒有unshipped line_items => 全部 line_items shipped => shipped
      shipment_status_is_shipped!
    else
      # 沒有任何partial && 有shipped && 有unshipped => partial
      shipment_status_is_partial!
    end
  end

  def editable?
    draft? || active?
  end

  private

    def rollback_stocks!
      line_item_commitments.each(&:destroy!)
      shipments.destroy_all
    end

    def setup_defaults
      self.order_number ||= self.class.next_number(company_id)
      self.status ||= 'active'
    end
end
