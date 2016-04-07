class CreatePurchaseOrderDetails < ActiveRecord::Migration
  def change
    create_table :purchase_order_details do |t|
      t.references :purchase_order, index: true
      t.references :variant, index: true
      t.integer :quantity
      t.integer :cost_per_unit

      t.timestamps null: false
    end
  end
end
