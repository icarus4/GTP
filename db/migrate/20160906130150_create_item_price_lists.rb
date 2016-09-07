class CreateItemPriceLists < ActiveRecord::Migration[5.0]
  def change
    create_table :item_price_lists do |t|
      t.references :item, null: false, foreign_key: true, index: true
      t.references :price_list, null: false, foreign_key: true, index: true
      t.decimal    :price, null: false, precision: 12, scale: 2

      t.timestamps
    end
  end
end
