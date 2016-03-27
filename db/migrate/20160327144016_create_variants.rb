class CreateVariants < ActiveRecord::Migration
  def change
    create_table :variants do |t|
      t.references :product,         null: false
      t.string     :sku
      t.string     :name
      t.decimal    :buy_price,       precision: 8, scale: 2
      t.decimal    :retail_price,    precision: 8, scale: 2
      t.decimal    :wholesale_price, precision: 8, scale: 2
      t.integer    :available_count, null: false, default: 0
      t.integer    :on_hand_count,   null: false, default: 0
      t.decimal    :weight_value
      t.references :weight_unit

      t.timestamps null: false
    end

    add_index :variants, :product_id
    add_index :variants, :sku
    add_index :variants, :name
  end
end
