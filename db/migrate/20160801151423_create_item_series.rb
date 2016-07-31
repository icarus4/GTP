class CreateItemSeries < ActiveRecord::Migration
  def change
    create_table :item_series do |t|
      t.references :company, null: false
      t.references :brand
      t.references :manufacturer
      t.integer    :storage_and_transport_condition
      t.text       :raw_material
      t.text       :food_additives
      t.text       :warnings

      t.timestamps null: false
    end
  end
end
