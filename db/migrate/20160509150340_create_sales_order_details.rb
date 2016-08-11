class CreateSalesOrderDetails < ActiveRecord::Migration
  def change
    create_table :sales_order_details do |t|
      t.references :sales_order, index: true, foreign_key: true
      t.references :variant, index: true,     foreign_key: true
      t.integer    :quantity
      t.integer    :unit_price

      t.timestamps null: false
      t.text       :notes
    end
  end
end
