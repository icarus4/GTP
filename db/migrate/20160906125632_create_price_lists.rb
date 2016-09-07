class CreatePriceLists < ActiveRecord::Migration[5.0]
  def change
    create_table :price_lists do |t|
      t.references :company, null: false, index: true, foreign_key: true
      t.string     :name, null: false
      t.integer    :price_list_type

      t.timestamps
    end
  end
end
