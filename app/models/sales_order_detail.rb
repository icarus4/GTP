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
