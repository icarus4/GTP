class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.integer :company_id
      t.integer :assignee_id
      t.integer :relationship_type, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.string :name
      t.string :email
      t.string :vat_number
      t.string :phone
      t.string :fax
      t.string :website
      t.text :description

      t.timestamps null: false
    end
  end
end
