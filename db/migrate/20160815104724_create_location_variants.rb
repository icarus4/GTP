class CreateLocationVariants < ActiveRecord::Migration
  def change
    create_table :location_variants do |t|
      t.references :company,      index: true, foreign_key: true
      t.references :bin_location, index: true, foreign_key: true
      t.references :variant,      index: true, foreign_key: true
      t.integer    :quantity,     null: false, default: 0

      t.timestamps null: false
    end
  end
end
