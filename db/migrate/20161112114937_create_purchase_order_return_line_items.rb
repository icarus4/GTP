class CreatePurchaseOrderReturnLineItems < ActiveRecord::Migration[5.0]
  def change
    create_table :purchase_order_return_line_items do |t|
      t.references :purchase_order_return, null: false, index: { name: 'index_por_line_items_on_purchase_order_return_id' }
      t.references :line_item,             null: false
      t.references :item,                  null: false
      t.integer    :quantity,              null: false

      t.timestamps
    end
  end
end
