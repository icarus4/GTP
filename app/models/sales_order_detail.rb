# == Schema Information
#
# Table name: sales_order_details
#
#  id             :integer          not null, primary key
#  sales_order_id :integer
#  variant_id     :integer
#  quantity       :integer
#  unit_price     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  note           :text
#
# Indexes
#
#  index_sales_order_details_on_sales_order_id  (sales_order_id)
#  index_sales_order_details_on_variant_id      (variant_id)
#

class SalesOrderDetail < ActiveRecord::Base
  belongs_to :variant
  belongs_to :sales_order

  def amount
    quantity * unit_price
  end

  def quantity_after_shipping
    variant.item.on_hand_count - quantity
  end
end
