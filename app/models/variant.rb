# == Schema Information
#
# Table name: variants
#
#  id                 :integer          not null, primary key
#  item_id            :integer          not null
#  quantity           :integer          default(0), not null
#  manufacturing_date :date
#  expiry_date        :date
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Variant < ActiveRecord::Base
  after_save :update_item_on_hand_count

  belongs_to :item
  has_many :purchase_order_details
  has_many :purchase_orders, through: :purchase_order_details
  has_many :sales_order_details
  has_many :sales_orders, through: :sales_order_details
  has_many :location_variants
  has_many :locations, through: :location_variants

  delegate :company, to: :item
  delegate :sku_name, to: :item


  def update_cache_columns!
    update!(quantity: location_variants.sum(:quantity))
  end

  def update_item_on_hand_count
    item.update_on_hand_count!
  end
end
