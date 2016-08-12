class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands do |t|
      t.references :company,  null: false, foreign_key: true
      t.string     :name,     null: false, limit: 255

      t.timestamps null: false
    end

    add_index :brands, [:company_id, :name], unique: true
  end
end
