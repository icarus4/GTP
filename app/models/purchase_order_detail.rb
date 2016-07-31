# == Schema Information
#
# Table name: purchase_order_details
#
#  id                 :integer          not null, primary key
#  purchase_order_id  :integer
#  item_id            :integer
#  quantity           :integer
#  unit_price         :integer
#  manufacturing_date :date
#  expiry_date        :date
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_purchase_order_details_on_item_id            (item_id)
#  index_purchase_order_details_on_purchase_order_id  (purchase_order_id)
#

class PurchaseOrderDetail < ActiveRecord::Base
  belongs_to :item
  belongs_to :purchase_order

  # validates :purchase_order_id, :variant_id, :quantity, :unit_price, presence: true # This causes cocoon failed

  def amount
    quantity * unit_price
  end

  def quantity_after_receiving
    item.on_hand_count + quantity
  end
end
