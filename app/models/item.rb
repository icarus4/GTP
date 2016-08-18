# == Schema Information
#
# Table name: items
#
#  id                    :integer          not null, primary key
#  company_id            :integer          not null
#  item_series_id        :integer
#  packaging_type_id     :integer
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
#  image                 :string
#  sku                   :string
#  name                  :string           default(""), not null
#  description           :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_items_on_company_id  (company_id)
#  index_items_on_name        (name)
#

class Item < ActiveRecord::Base
  mount_uploader :image, ImageUploader

  after_initialize :setup_defaults

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
  belongs_to :item_series
  belongs_to :packaging_type

  has_many :variants, -> { order(:expiry_date) }, dependent: :destroy
  has_many :purchase_order_details
  has_many :purchase_orders, through: :purchase_order_details
  has_many :sales_order_details
  has_many :sales_orders, through: :sales_order_details

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
  validates :weight_unit,  presence: true
  validates :on_hand_count, :available_count, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :sku, uniqueness: { scope: :company_id }, allow_blank: true
  validates :packaging_type_id, presence: true

  scope :includes_for_api, -> { includes(:variants, :packaging_type)  }

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

    def setup_defaults
      self.weight_unit = 'g'
    end
end
