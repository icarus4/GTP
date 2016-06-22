class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.references :company
      t.references :supplier
      t.references :item_type
      t.references :brand
      t.string     :unit
      t.integer    :status,           default: 0,  null: false
      t.boolean    :manufactured_by_self, default: false, null: false
      t.string     :unit
      t.integer    :available_count, null: false, default: 0
      t.integer    :on_hand_count,   null: false, default: 0
      t.string     :sku
      t.string     :name,             default: '', null: false, limit: 255
      t.text       :description

      t.timestamps null: false
    end

    add_index :items, :name
    add_index :items, :company_id
  end
end
