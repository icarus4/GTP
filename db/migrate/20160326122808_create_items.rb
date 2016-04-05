class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.references :company
      t.references :supplier
      t.references :item_type
      t.references :brand
      t.integer  :status,           default: 0,  null: false
      t.string   :name,             default: '', null: false, limit: 255
      t.text     :description
      t.datetime :deleted_at

      t.timestamps null: false
    end

    add_index :items, :name
    add_index :items, :company_id
  end
end
