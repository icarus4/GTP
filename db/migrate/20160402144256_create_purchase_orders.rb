class CreatePurchaseOrders < ActiveRecord::Migration
  def change
    create_table :purchase_orders do |t|
      t.references :company
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
  end
end
