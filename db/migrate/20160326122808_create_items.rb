class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.references :company, null: false, foreign_key: true
      t.references :item_series,          foreign_key: true
      t.references :packaging_type,       foreign_key: true
      t.integer    :available_count,      null: false, default: 0
      t.integer    :on_hand_count,        null: false, default: 0
      t.integer    :cost_per_unit
      t.integer    :purchase_price
      t.integer    :wholesale_price
      t.integer    :retail_price
      t.integer    :low_stock_alert_level
      t.integer    :status,               null: false, default: 0, limit: 1
      t.integer    :weight_unit,          limit: 1
      t.decimal    :weight_value,         precision: 10, scale: 2
      t.boolean    :manufactured_by_self, null: false, default: false
      t.boolean    :expirable,            null: false, default: true
      t.string     :image
      t.string     :sku
      t.string     :name,                 null: false, default: ''
      t.text       :description

      t.timestamps null: false
    end

    add_index :items, :name
    add_index :items, :company_id
  end
end
