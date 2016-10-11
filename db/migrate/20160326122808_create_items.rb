class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.references :company, null: false, index: true
      t.references :item_series
      t.references :packaging_type
      t.integer    :available_count,      null: false, default: 0
      t.integer    :on_hand_count,        null: false, default: 0
      t.decimal    :cost_per_unit,        precision: 10, scale: 2
      t.decimal    :purchase_price,       precision: 10, scale: 2
      t.decimal    :wholesale_price,      precision: 10, scale: 2
      t.decimal    :retail_price,         precision: 10, scale: 2
      t.integer    :low_stock_alert_level
      t.integer    :status,               null: false, default: 0, limit: 1
      t.integer    :weight_unit,          limit: 1
      t.decimal    :weight_value,         precision: 10, scale: 2
      t.boolean    :manufactured_by_self, null: false, default: false
      t.boolean    :expirable,            null: false, default: true
      t.boolean    :sellable,             null: false, default: true
      t.boolean    :purchasable,          null: false, default: true
      t.string     :image
      t.string     :sku,                  index: true
      t.string     :sku_from_supplier
      t.string     :name,                 null: false, default: '', index: true
      t.text       :description

      t.timestamps null: false
    end
  end
end
