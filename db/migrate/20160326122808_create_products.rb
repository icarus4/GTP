class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.references :company
      t.references :supplier
      t.references :product_type
      t.references :brand
      t.integer  :status,           default: 0,  null: false
      t.string   :name,             default: '', null: false, limit: 255
      t.text     :description
      t.datetime :deleted_at

      t.timestamps null: false
    end

    add_index :products, :name
    add_index :products, :company_id
  end
end
