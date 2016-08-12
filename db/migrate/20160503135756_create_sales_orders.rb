class CreateSalesOrders < ActiveRecord::Migration
  def change
    create_table :sales_orders do |t|
      t.references :company,            foreign_key: true
      t.references :customer
      t.references :bill_to_location
      t.references :ship_to_location
      t.references :ship_from_location
      t.references :assignee
      t.string     :status
      t.integer    :total_amount
      t.date       :issued_on
      t.date       :shipped_on
      t.timestamps null: false
      t.string     :order_number,  limit: 64
      t.string     :contact_email, limit: 64
      t.text       :notes
    end

    add_index :sales_orders, [:company_id, :customer_id]
    add_index :sales_orders, :status
    add_foreign_key :sales_orders, :companies, column: :customer_id
    add_foreign_key :sales_orders, :locations, column: :bill_to_location_id
    add_foreign_key :sales_orders, :locations, column: :ship_to_location_id
    add_foreign_key :sales_orders, :locations, column: :ship_from_location_id
  end
end
