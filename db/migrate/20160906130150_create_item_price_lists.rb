class CreateItemPriceLists < ActiveRecord::Migration[5.0]
  def change
    create_table :item_price_lists do |t|
      t.references :item, null: false
      t.references :price_list, null: false
      t.decimal    :price, null: false, precision: 12, scale: 2

      t.timestamps
    end

    add_index :item_price_lists, [:item_id, :price_list_id], unique: true
  end
end
