class CreatePurchaseOrderLineItems < ActiveRecord::Migration[5.0]
  def change
    create_table :purchase_order_line_items do |t|
      t.references :purchase_order,          null: false, index: true
      t.references :procurement,             index: true
      t.references :item,       null: false, index: true
      t.references :variant,                 index: true
      t.references :bin_location
      t.references :location_variant
      t.integer    :quantity,   null: false
      t.decimal    :unit_price, null: false, precision: 10, scale: 2
      t.decimal    :tax_rate,                precision:  4, scale: 1
      t.decimal    :tax,                     precision: 10, scale: 2
      t.decimal    :total,      null: false, precision: 12, scale: 2

      t.timestamps
    end
  end
end
