# == Schema Information
#
# Table name: variants
#
#  id              :integer          not null, primary key
#  item_id         :integer          not null
#  sku             :string
#  name            :string
#  buy_price       :integer
#  cost_per_unit   :integer
#  retail_price    :integer
#  wholesale_price :integer
#  available_count :integer          default(0), not null
#  on_hand_count   :integer          default(0), not null
#  weight_value    :decimal(8, 2)
#  weight_unit_id  :integer
#  description     :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Variant < ActiveRecord::Base
  belongs_to :item
  has_many :purchase_order_details
  has_many :purchase_orders, through: :purchase_order_details
  has_many :location_variants

  delegate :company, to: :item

  validates :on_hand_count, :available_count, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :cost_per_unit, presence: true

  def sku_name
    "#{sku} #{name}"
  end

  def update_cache_columns!
    self.on_hand_count = location_variants.sum(:quantity)
    self.available_count = on_hand_count + quantity_in_active_orders
    save!
  end

  def update_on_hand_count!
    self.on_hand_count = location_variants.sum(:quantity)
    save!
  end

  def update_available_count!
    self.available_count = on_hand_count + quantity_in_active_orders
    save!
  end

  private

    def quantity_in_active_orders
      quantity_in_active_purchase_orders - quantity_in_active_sales_orders
    end

    def quantity_in_active_purchase_orders
      PurchaseOrderDetail.joins(:purchase_order).where(variant_id: id, purchase_orders: { company_id: company.id, status: 1 }).sum(:quantity)
    end

    def quantity_in_active_sales_orders
      0 #FIXME: NIY
    end
end
