class AddShipmentStatusAndShippedQuantityToSalesOrderLineItems < ActiveRecord::Migration[5.0]
  def change
    add_column :sales_order_line_items, :shipment_status, :integer, default: 0, null: false
    add_column :sales_order_line_items, :shipped_quantity, :integer, default: 0, null: false
  end
end
