class AddReturnedQuantityToOrderLineItems < ActiveRecord::Migration[5.0]
  def up
    add_column :order_line_items, :returned_quantity, :integer, default: 0, null: false
    Order::LineItem.find_each do |purchase_order_line_item|
      purchase_order_line_item.returned_quantity = purchase_order_line_item.purchase_order_return_line_items.sum(:quantity)
      purchase_order_line_item.save!
    end
  end

  def down
    remove_column :order_line_items, :returned_quantity
  end
end
