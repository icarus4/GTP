class CreateSalesOrderDetails < ActiveRecord::Migration
  def change
    create_table :sales_order_details do |t|
      t.references :sales_order, index: true
      t.references :variant, index: true
      t.integer :quantity
      t.integer :cost_per_unit

      t.timestamps null: false
    end
  end
end
