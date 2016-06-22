class CreateVariants < ActiveRecord::Migration
  def change
    create_table :variants do |t|
      t.references :item,            null: false
      t.integer    :quantity,        null: false, default: 0
      t.date       :manufacturing_date
      t.date       :expiry_date

      t.timestamps null: false
    end

    add_index :variants, :item_id
  end
end
