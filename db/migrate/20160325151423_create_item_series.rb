class CreateItemSeries < ActiveRecord::Migration
  def change
    create_table :item_series do |t|
      t.references :company, null: false, index: true, foreign_key: true
      t.references :brand,                             foreign_key: true
      t.references :manufacturer,                      foreign_key: true
      t.integer    :storage_and_transport_condition
      t.string     :name
      t.string     :storage_and_transport_condition_note
      t.text       :raw_material
      t.text       :main_and_auxiliary_material
      t.text       :food_additives
      t.text       :warnings

      t.timestamps null: false
    end
  end
end
