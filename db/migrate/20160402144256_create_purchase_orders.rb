class CreatePurchaseOrders < ActiveRecord::Migration
  def change
    create_table :purchase_orders do |t|
      t.references :company,          foreign_key: true
      t.references :supplier
      t.references :bill_to_location
      t.references :ship_to_location
      t.string     :status
      t.integer    :total_amount
      t.date       :due_on
      t.timestamps null: false
      t.string     :order_number,  limit: 64
      t.string     :contact_email, limit: 64
      t.text       :notes
    end

    add_index :purchase_orders, [:company_id, :supplier_id]
    add_index :purchase_orders, :status
    add_foreign_key :purchase_orders, :companies, column: :supplier_id
    add_foreign_key :purchase_orders, :locations, column: :bill_to_location_id
    add_foreign_key :purchase_orders, :locations, column: :ship_to_location_id
  end
end
