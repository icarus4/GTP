class CreateSalesOrderLineItemCommitments < ActiveRecord::Migration[5.0]
  def change
    create_table :sales_order_line_item_commitments do |t|
      t.references :line_item,               index: true
      t.references :bin_location,            index: true
      t.references :location,                index: true
      t.references :location_variant, index: { name: 'index_line_item_commitments_on_location_variant_id' }
      t.references :variant,                 index: true
      t.references :item,                    index: true
      t.references :shipment,                index: true
      t.integer    :quantity,   null: false, default: 0

      t.timestamps
    end
  end
end
