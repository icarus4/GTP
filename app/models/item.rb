# == Schema Information
#
# Table name: items
#
#  id                    :integer          not null, primary key
#  company_id            :integer          not null
#  item_series_id        :integer
#  available_count       :integer          default(0), not null
#  on_hand_count         :integer          default(0), not null
#  cost_per_unit         :integer
#  purchase_price        :integer
#  wholesale_price       :integer
#  retail_price          :integer
#  low_stock_alert_level :integer
#  status                :integer          default(0), not null
#  weight_unit           :integer
#  weight_value          :decimal(10, 2)
#  manufactured_by_self  :boolean          default(FALSE), not null
#  expirable             :boolean          default(TRUE), not null
#  sku                   :text
#  name                  :text             default(""), not null
#  description           :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  image                 :string
#
# Indexes
#
#  index_items_on_company_id  (company_id)
#  index_items_on_name        (name)
#

class Item < ActiveRecord::Base
  attr_accessor :initial_location_id
  mount_uploader :image, ImageUploader

  delegate :supplier,
           :brand,
           :manufacturer,
           :storage_and_transport_condition,
           :storage_and_transport_condition_in_chinese,
           :storage_and_transport_condition_note,
           :raw_material,
           :food_additives,
           :warnings,
           to: :item_series

  belongs_to :company
  belongs_to :supplier
  belongs_to :item_series

  has_many :variants, -> { order(:expiry_date) }, dependent: :destroy
  has_many :purchase_order_details
  has_many :purchase_orders, through: :purchase_order_details
  has_many :sales_order_details
  has_many :sales_orders, through: :sales_order_details

  validates_associated :variants

  accepts_nested_attributes_for :variants

  enum status: {
    active: 0,
    disabled: 1,
  }

  enum weight_unit: {
    g:  0,
    kg: 1,
  }

  validates :name,         presence: true
  validates :company_id,   presence: true
  validates :on_hand_count, :available_count, presence: true, numericality: { greater_than_or_equal_to: 0 }


  def sku_name
    "#{sku} #{name}"
  end

  def update_available_count!
    update!(available_count: on_hand_count + quantity_in_active_orders)
  end

  def update_on_hand_count!
    update!(on_hand_count: variants.sum(:quantity))
  end

  private

    def quantity_in_active_orders
      quantity_in_active_purchase_orders - quantity_in_unshipped_sales_orders
    end

    def quantity_in_active_purchase_orders
      raise "Valid statuses of PurchaseOrder changed, please check the following calculation is correct or not" if PurchaseOrder::VALID_STATUSES != %w(draft active received)
      purchase_order_details.joins(:purchase_order).where(purchase_orders: { company_id: company_id, status: 'active' }, item_id: id).sum(:quantity)
    end

    def quantity_in_unshipped_sales_orders
      raise "Valid statuses of SalesOrder changed, please check the following calculation is correct or not" if SalesOrder::VALID_STATUSES != %w(draft active finalized fulfilled)
      SalesOrderDetail.joins({variant: :item}, :sales_order).where(variants: { item_id: id }, sales_orders: { company_id: company_id, status: ['active', 'finalized']}).sum(:quantity)
    end
end
