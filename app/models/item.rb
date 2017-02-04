# == Schema Information
#
# Table name: items
#
#  id                    :integer          not null, primary key
#  company_id            :integer          not null
#  item_series_id        :integer
#  packaging_type_id     :integer
#  cost_per_unit         :decimal(10, 2)
#  purchase_price        :decimal(10, 2)
#  wholesale_price       :decimal(10, 2)
#  retail_price          :decimal(10, 2)
#  low_stock_alert_level :integer
#  status                :integer          default("active"), not null
#  weight_unit           :integer
#  weight_value          :decimal(10, 2)
#  manufactured_by_self  :boolean          default(FALSE), not null
#  expirable             :boolean          default(TRUE), not null
#  sellable              :boolean          default(TRUE), not null
#  purchasable           :boolean          default(TRUE), not null
#  image                 :string
#  sku                   :string
#  sku_from_supplier     :string
#  name                  :string           default(""), not null
#  description           :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  quantity              :integer          default(0), not null
#  committed_quantity    :integer          default(0), not null
#  sellable_quantity     :integer          default(0), not null
#
# Indexes
#
#  index_items_on_company_id      (company_id)
#  index_items_on_item_series_id  (item_series_id)
#  index_items_on_name            (name)
#  index_items_on_sku             (sku)
#

class Item < ApplicationRecord
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
  has_many :item_price_lists
  has_many :price_lists, through: :item_price_lists
  has_many :packs, class_name: "Item::Pack"

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
  validates :quantity,           presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :committed_quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :sellable_quantity,  presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :sku, uniqueness: { scope: :company_id }, allow_blank: true
  validates :packaging_type_id, presence: true
  validates :wholesale_price, :retail_price, :purchase_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :description, length: { maximum: 5000 }

  auto_strip_attributes :name, :sku, :sku_from_supplier, :description

  scope :includes_for_api, -> { includes(:variants, :packaging_type, :packs, item_price_lists: :price_list)  }

  def sku_name
    "#{sku} #{name}"
  end

  def update_cache_columns!
    self.quantity           = variants.sum(:quantity)
    self.committed_quantity = variants.sum(:committed_quantity)
    self.sellable_quantity  = variants.sum(:sellable_quantity)
    save!
  end

  private

    def setup_defaults
      # 用 #has_attribute? 檢查欄位是否有被select
      self.weight_unit ||= 'g' if has_attribute?(:weight_unit)
      self.sellable    = true if has_attribute?(:sellable) && sellable.nil?    # Don't use ||= for boolean
      self.purchasable = true if has_attribute?(:purchasable) && purchasable.nil? # Don't use ||= for boolean
    end
end
