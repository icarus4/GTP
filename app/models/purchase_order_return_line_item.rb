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
  after_save :update_location_variant!, :update_returned_quantity!
  after_destroy :update_location_variant_after_destroy!, :update_returned_quantity!

  belongs_to :purchase_order_return
  belongs_to :purchase_order_line_item, class_name: 'Order::LineItem', foreign_key: :line_item_id
  belongs_to :item

  validates :purchase_order_return_id, presence: true
  validates :line_item_id, presence: true, uniqueness: { scope: :purchase_order_return_id }
  validates :item_id, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }

  private

    # 扣除退貨的庫存數字
    #
    # TODO:
    # 目前先假設沒有搬移，因此直接扣掉 location_variant.quantity
    # 未來需要確認產品是否有搬移過
    def update_location_variant!
      on_hand_quantity_increase = (quantity_was || 0) - quantity
      lv = purchase_order_line_item.location_variant
      lv.quantity += on_hand_quantity_increase
      lv.save!
    end

    # 扣除退貨的庫存數字
    #
    # TODO:
    # 目前先假設沒有搬移，因此直接扣掉 location_variant.quantity
    # 未來需要確認產品是否有搬移過
    def update_location_variant_after_destroy!
      lv = purchase_order_line_item.location_variant
      lv.quantity += quantity
      lv.save!
    end

    def update_purchase_order_return_status!
      purchase_order_return.purchase_order.update_return_status!
    end

    def update_returned_quantity!
      purchase_order_line_item.update_returned_quantity!
    end
end
