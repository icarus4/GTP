# == Schema Information
#
# Table name: sales_orders
#
#  id                      :integer          not null, primary key
#  company_id              :integer
#  partner_id              :integer
#  bill_to_location_id     :integer
#  ship_to_location_id     :integer
#  ship_from_location_id   :integer
#  assignee_id             :integer
#  payment_method_id       :integer
#  status                  :integer          default("draft"), not null
#  invoice_status          :integer          default("uninvoiced"), not null
#  packing_status          :integer          default(0), not null
#  shipment_status         :integer          default("unshipped"), not null
#  payment_status          :integer          default("unpaid"), not null
#  tax_treatment           :integer          default("exclusive"), not null
#  line_items_count        :integer          default(0), not null
#  total_units             :integer          default(0), not null
#  subtotal                :decimal(12, 2)
#  total_tax               :decimal(12, 2)
#  total_amount            :decimal(12, 2)
#  issued_on               :date
#  expected_delivery_date  :date
#  order_number            :string
#  email                   :string
#  phone                   :string
#  notes                   :text
#  extra_info              :jsonb
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  invoiced_quantity       :integer
#  uninvoiced_quantity     :integer
#  invoiced_total_amount   :decimal(12, 2)
#  uninvoiced_total_amount :decimal(12, 2)
#  paid_total_amount       :decimal(12, 2)
#  unpaid_total_amount     :decimal(12, 2)
#
# Indexes
#
#  index_sales_orders_on_company_id_and_partner_id  (company_id,partner_id)
#  index_sales_orders_on_order_number               (order_number)
#

class SalesOrder < ApplicationRecord
  include Taxable
  include AASM

  before_validation :setup_defaults
  after_save :update_status!, if: :shipment_status_changed?

  belongs_to :company
  belongs_to :partner
  belongs_to :bill_to_location, class_name: 'Location', foreign_key: :bill_to_location_id
  belongs_to :ship_to_location, class_name: 'Location', foreign_key: :ship_to_location_id
  belongs_to :ship_from_location, class_name: 'Location', foreign_key: :ship_from_location_id
  belongs_to :assignee, -> { select(:id, :name, :email, :phone_number) }, class_name: 'User'

  has_many :line_items
  has_many :line_item_commitments, through: :line_items
  has_many :shipments
  has_many :invoices
  has_many :invoice_line_items, through: :invoices
  has_many :payments

  validates :status,
            :company_id,
            :bill_to_location_id,
            :ship_to_location_id,
            :ship_from_location_id, presence: true
  validates :order_number, presence: true, uniqueness: { scope: :company_id }
  validates :invoiced_quantity,       presence: true, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :invoiced_total_amount,   presence: true, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :uninvoiced_quantity,     presence: true, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :uninvoiced_total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

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
      transitions from: :draft, to: :active, after: :commit_stocks!
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
  # TODO: 判斷 shipment_status 的方式可修改為: 在 sales order 加入shipped_quantity，只要shipped_quantity == total_units就是shipped
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

  def update_invoice_related_columns!
    update_invoice_related_columns
    save!
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
      self.order_number            ||= self.class.next_number(company_id)
      self.invoiced_quantity       ||= 0
      self.invoiced_total_amount   ||= 0
      self.uninvoiced_quantity     ||= total_units
      self.uninvoiced_total_amount ||= total_amount
      self.paid_total_amount       ||= 0
      self.unpaid_total_amount     ||= total_amount
      self.invoice_status          ||= 'uninvoiced'
      self.payment_status          ||= 'unpaid'
    end

    def commit_stocks!
      line_items.each do |line_item|
        # 從庫存中尋找適當的貨品保留作為出貨用
        # 找到的 location_variant 的數量不一定足夠，因此用迴圈逐一找尋，直到總數量符合出貨量
        remaining_quantity = line_item.quantity
        offset = 0
        loop do
          # 找出最快過期的出貨
          chosen_lv = LocationVariant.where(company_id: company_id, location: ship_from_location, item_id: line_item.item_id)
                                     .default_sales_committed_sequence
                                     .offset(offset).first
          break if chosen_lv.nil?
          committed_quantity = chosen_lv.sellable_quantity >= remaining_quantity ? remaining_quantity : chosen_lv.sellable_quantity
          commitment = SalesOrder::LineItemCommitment.create!(
            line_item:        line_item,
            location_variant: chosen_lv,
            quantity:         committed_quantity
          )
          remaining_quantity -= committed_quantity
          if remaining_quantity == 0
            break
          elsif remaining_quantity < 0
            raise "Should not be here"
          end
          offset += 1
        end
      end
    end

    def update_invoice_related_columns
      self.invoiced_total_amount   = invoices.sum(:total_amount)
      self.uninvoiced_total_amount = total_amount - invoiced_total_amount

      self.invoiced_quantity       = invoices.sum(:total_units)
      self.uninvoiced_quantity     = total_units - invoiced_quantity

      self.unpaid_total_amount = invoices.sum(:unpaid_amount)
      self.paid_total_amount   = invoices.sum(:paid_amount)

      self.invoice_status = if !invoices.exists?
                              'uninvoiced'
                            elsif invoiced_quantity == total_units
                              'invoiced'
                            elsif invoiced_quantity == 0
                              'uninvoiced'
                            else
                              'partial'
                            end

      self.payment_status = if !payments.exists?
                              'unpaid'
                            elsif unpaid_total_amount == 0
                              'paid'
                            elsif paid_total_amount == 0
                              'unpaid'
                            else
                              'partial'
                            end
    end
end
