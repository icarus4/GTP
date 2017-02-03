class RemoveBinLocationRelatedColumns < ActiveRecord::Migration[5.0]
  def up
    rename_column :purchase_order_line_items, :bin_location_id, :location_id
    remove_column :location_variants, :bin_location_id, :integer, index: true
    remove_column :sales_order_line_item_commitments, :bin_location_id, :integer, index: true
    drop_table :bin_locations
  end

  def down
    rename_column :purchase_order_line_items, :location_id, :bin_location_id

    add_column :location_variants, :bin_location_id, :integer, index: true
    add_index :location_variants, :bin_location_id

    add_column :sales_order_line_item_commitments, :bin_location_id, :integer, index: true
    add_index :sales_order_line_item_commitments, :bin_location_id

    create_table :bin_locations do |t|
      t.references :location, null: false, index: true
      t.string     :name

      t.timestamps null: false
    end
  end
end
