class CreateLocationVariants < ActiveRecord::Migration
  def change
    create_table :location_variants do |t|
      t.references :company, index: true
      t.references :location, index: true
      t.references :variant, index: true
      t.integer :quantity

      t.timestamps null: false
    end
  end
end
