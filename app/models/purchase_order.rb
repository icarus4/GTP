# == Schema Information
#
# Table name: purchase_orders
#
#  id                     :integer          not null, primary key
#  company_id             :integer          not null
#  partner_id             :integer
#  currency_id            :integer
#  payment_method_id      :integer
#  assignee_id            :integer
#  bill_to_location_id    :integer
#  ship_from_location_id  :integer
#  ship_to_location_id    :integer
#  line_items_count       :integer          default(0), not null
#  order_number           :string
#  status                 :integer          default("draft"), not null
#  email                  :string
#  return_status          :integer          default("unreturned"), not null
#  tax_treatment          :integer          default("exclusive"), not null
#  total_units            :integer
#  subtotal               :decimal(12, 2)
#  total_tax              :decimal(12, 2)
#  total_amount           :decimal(12, 2)
#  paid_on                :date
#  expected_delivery_date :date
#  notes                  :text
#  extra_info             :jsonb
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_purchase_orders_on_company_id_and_partner_id  (company_id,partner_id)
#  index_purchase_orders_on_order_number               (order_number)
#

class PurchaseOrder < ApplicationRecord
  include Taxable

  store_accessor :extra_info,
                 :goods_declaration_number

  after_initialize :setup_defaults

  # TODO: 研究是否有需要把運算邏輯加入 callback
  # before_save :update_total_amount
  # after_save :update_item_available_count!


  belongs_to :company
  belongs_to :partner
  belongs_to :bill_to_location, class_name: 'Location', foreign_key: :bill_to_location_id
  belongs_to :ship_to_location, class_name: 'Location', foreign_key: :ship_to_location_id
  belongs_to :currency
  belongs_to :payment_method
  belongs_to :assignee, class_name: 'User'

  has_many :line_items
  has_many :items,    through: :line_items
  has_many :variants, through: :line_items
  has_many :procurements
  has_many :purchase_order_returns
  has_many :purchase_order_return_line_items, through: :purchase_order_returns, source: :line_items

  # accepts_nested_attributes_for :details, reject_if: :all_blank, allow_destroy: true
  # accepts_nested_attributes_for :items

  validates :status,
            :company_id,
            :partner_id,
            :bill_to_location_id,
            :ship_to_location_id,
            presence: true

  validates :order_number, presence: true, uniqueness: { scope: :company_id }
  validates :total_units,  numericality: { only_integer: true }, allow_nil: true
  validates :subtotal,     numericality: true, allow_nil: true
  validates :total_tax,    numericality: true, allow_nil: true
  validates :total_amount, numericality: true, allow_nil: true

  auto_strip_attributes :email, :notes, :order_number

  enum status: { draft: 0, active: 1, received: 2 }
  enum return_status: { unreturned: 0, partial: 1, returned: 2 }, _prefix: :return_status_is

  def self.next_number(company_id)
    where(company_id: company_id).maximum(:order_number).try(:next) || 'PO0001'
  end

  def calculate!
    # See Taxable
    calcualte_subtotal
    calcualte_total_units
    calculate_total_tax
    calculate_total_amount
    save!
  end

  def all_line_items_are_procured?
    line_items.count > 0 && !line_items.where(procurement_id: nil).exists?
  end

  # 商品收貨/退貨時須執行此method
  def update_return_status!
    # return hash as follows:
    # {
    #   line_item_1_id => line_item_1_quantity,
    #   line_item_2_id => line_item_2_quantity,
    #   ...
    # }
    return_line_items = purchase_order_return_line_items.select(:line_item_id, :quantity).group(:line_item_id).sum(:quantity)
    _procured_line_items = line_items.procured.pluck(:id, :quantity).to_h

    if return_line_items == _procured_line_items # 退貨商品與訂單商品之品項及數量完全相同
      return_status_is_returned!
    elsif return_line_items.blank? # 無退貨商品
      return_status_is_unreturned!
    elsif return_line_items.present? && return_line_items != _procured_line_items # 部分商品退貨
      return_status_is_partial!
    else
      raise 'Should not happen'
    end
  end

  private

    def setup_defaults
      self.order_number ||= (self.class.where(company_id: company_id).maximum(:order_number).try(:next) || 'PO0001') if company_id
      self.status ||= 'active'
    end
end
