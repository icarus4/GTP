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

class SalesOrder < ActiveRecord::Base
  include Taxable

  after_initialize :setup_defaults

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

  enum status: { draft: 0, active: 1, finalized: 2, fulfilled: 3 }
  enum invoice_status:  { uninvoiced: 0, partial: 1, invoiced: 2 }, _prefix: :invoice_status_is
  enum shipment_status: { unshipped: 0,  partial: 1, shipped: 2 },  _prefix: :shipment_status_is
  enum payment_status:  { unpaid: 0,     partial: 1, paid: 2 },     _prefix: :payment_status_is

  auto_strip_attributes :email, :phone, :notes

  def self.next_number(company_id)
    where(company_id: company_id).maximum(:order_number).try(:next) || 'SO0001'
  end

  def calculate!
    # See Taxable
    calcualte_subtotal
    calcualte_total_units
    calculate_total_tax
    calculate_total_amount
    save!
  end

  def update_status!
    if finalized?
      if line_item_commitments.exists? && !line_item_commitments.where(shipment_id: nil).exists?
        fulfilled!
      end
    end
  end

  def update_shipment_status!
    if line_items.shipment_status_is_partial.exists?
      shipment_status_is_partial!
    elsif !line_items.shipment_status_is_shipped.exists?
      shipment_status_is_unshipped!
    elsif !line_items.shipment_status_is_unshipped.exists?
      shipment_status_is_shipped!
    else
      raise "Should not be here"
    end
  end

  private

    def setup_defaults
      self.order_number ||= self.class.next_number(company_id)
      self.status ||= 'active'
    end
end
