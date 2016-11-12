# == Schema Information
#
# Table name: purchase_order_return_line_items
#
#  id                       :integer          not null, primary key
#  purchase_order_return_id :integer          not null
#  line_item_id             :integer          not null
#  item_id                  :integer          not null
#  quantity                 :integer          not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
# Indexes
#
#  index_por_line_items_on_purchase_order_return_id        (purchase_order_return_id)
#  index_purchase_order_return_line_items_on_item_id       (item_id)
#  index_purchase_order_return_line_items_on_line_item_id  (line_item_id)
#

class PurchaseOrderReturnLineItem < ApplicationRecord
  belongs_to :purchase_order_return
  belongs_to :line_item, class_name: 'Order::LineItem'
  belongs_to :item

  validates :purchase_order_return_id, presence: true
  validates :line_item_id, presence: true, uniqueness: { scope: :purchase_order_return_id }
  validates :item_id, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
end
