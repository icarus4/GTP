class CreatePurchaseOrderDetails < ActiveRecord::Migration
  def change
    create_table :purchase_order_details do |t|
      t.references :purchase_order, index: true
      t.references :item, index: true
      t.references :bin_location
      t.integer    :quantity
      t.integer    :unit_price
      t.date       :manufacturing_date
      t.date       :expiry_date

      t.timestamps null: false
    end
  end
end
