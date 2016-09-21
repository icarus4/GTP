class CreateItemPacks < ActiveRecord::Migration[5.0]
  def change
    create_table :item_packs do |t|
      t.references :item, index: true
      t.string  :name, null: false
      t.integer :size, null: false

      t.timestamps
    end
  end
end
