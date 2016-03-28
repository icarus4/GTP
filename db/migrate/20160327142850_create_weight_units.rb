class CreateWeightUnits < ActiveRecord::Migration
  def change
    create_table :weight_units do |t|
      t.references :company,  null: false
      t.string     :name,     null: false, limit: 32

      t.timestamps null: false
    end

    add_index :weight_units, [:company_id, :name], unique: true
  end
end
