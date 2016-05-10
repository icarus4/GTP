# == Schema Information
#
# Table name: sales_order_details
#
#  id             :integer          not null, primary key
#  sales_order_id :integer
#  variant_id     :integer
#  quantity       :integer
#  cost_per_unit  :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class SalesOrderDetail < ActiveRecord::Base
  belongs_to :variant
  belongs_to :purchase_order

  accepts_nested_attributes_for :variant, :reject_if => :all_blank

  def amount
    quantity * cost_per_unit
  end

  def quantity_after_receiving
    variant.on_hand_count - quantity
  end
end
