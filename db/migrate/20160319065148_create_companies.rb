class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.integer :company_id
      t.integer :assignee_id
      t.integer :status, null: false, default: 0
      t.string :type, null: false, default: ''
      t.string :name
      t.string :email
      t.string :vat_number
      t.string :phone
      t.string :fax
      t.string :website
      t.jsonb  :settings, null: false, default: {}
      t.text :description

      t.timestamps null: false
    end

    add_index :companies, :company_id
    add_index :companies, :type
  end
end
