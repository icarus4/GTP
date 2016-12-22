class CreateSalesOrders < ActiveRecord::Migration
  def change
    create_table :sales_orders do |t|
      t.references :company
      t.references :partner
      t.references :bill_to_location
      t.references :ship_to_location
      t.references :ship_from_location
      t.references :assignee
      t.references :payment_method
      t.integer    :status,                  null: false, default: 0
      t.integer    :tax_treatment,           null: false, default: 0
      t.integer    :line_items_count,        null: false, default: 0
      t.integer    :total_units, default: 0, null: false
      t.decimal    :subtotal,     precision: 12, scale: 2
      t.decimal    :total_tax,    precision: 12, scale: 2
      t.decimal    :total_amount, precision: 12, scale: 2
      t.date       :issued_on
      t.date       :expected_delivery_date
      t.string     :order_number,  index: true
      t.string     :email
      t.text       :notes
      t.jsonb      :extra_info

      t.timestamps null: false
    end

    add_index :sales_orders, [:company_id, :partner_id]
    add_index :sales_orders, :status
  end
end
