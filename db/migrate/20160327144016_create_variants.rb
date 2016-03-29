class CreateVariants < ActiveRecord::Migration
  def change
    create_table :variants do |t|
      t.references :product,         null: false
      t.string     :sku
      t.string     :name
      t.integer    :buy_price
      t.integer    :cost_per_unit
      t.integer    :retail_price
      t.integer    :wholesale_price
      t.integer    :available_count, null: false, default: 0
      t.integer    :on_hand_count,   null: false, default: 0
      t.decimal    :weight_value,    precision: 8, scale: 2
      t.references :weight_unit
      t.text       :description

      t.timestamps null: false
    end

    add_index :variants, :product_id
    add_index :variants, :sku
    add_index :variants, :name
  end
end
