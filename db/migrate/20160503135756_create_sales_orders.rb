class CreateSalesOrders < ActiveRecord::Migration
  def change
    create_table :sales_orders do |t|
      t.references :company
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
  end
end
