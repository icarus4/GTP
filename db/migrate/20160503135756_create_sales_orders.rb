class CreateSalesOrders < ActiveRecord::Migration
  def change
    create_table :sales_orders do |t|
      t.integer :company_id
      t.integer :partner_id
      t.integer :bill_to_location_id
      t.integer :ship_to_location_id
      t.integer :ship_from_location_id
      t.integer :assignee_id
      t.integer :payment_method_id
      t.integer :status,                  null: false, default: 0
      t.integer :invoice_status,          null: false, default: 0
      t.integer :packing_status,          null: false, default: 0
      t.integer :shipment_status,         null: false, default: 0
      t.integer :payment_status,          null: false, default: 0
      t.integer :tax_treatment,           null: false, default: 0
      t.integer :line_items_count,        null: false, default: 0
      t.integer :total_units, default: 0, null: false
      t.decimal :subtotal,     precision: 12, scale: 2
      t.decimal :total_tax,    precision: 12, scale: 2
      t.decimal :total_amount, precision: 12, scale: 2
      t.date    :issued_on
      t.date    :expected_delivery_date
      t.string  :order_number
      t.string  :email
      t.string  :phone
      t.text    :notes
      t.jsonb   :extra_info

      t.timestamps null: false
    end

    add_index :sales_orders, [:company_id, :partner_id]
    add_index :sales_orders, :order_number
  end
end
