class CreateSalesOrderLineItems < ActiveRecord::Migration[5.0]
  def change
    create_table :sales_order_line_items do |t|
      t.references :sales_order, index: true, null: false
      t.references :shipment,    index: true
      t.references :item,        index: true, null: false
      t.references :variant,     index: true
      t.integer    :bin_location_id
      t.integer    :location_variant_id
      t.integer    :quantity,   null: false
      t.decimal    :unit_price, null: false, precision: 10, scale: 2
      t.decimal    :tax_rate,                precision:  4, scale: 1
      t.decimal    :tax,                     precision: 10, scale: 2
      t.decimal    :total,      null: false, precision: 12, scale: 2

      t.timestamps
    end
  end
end
