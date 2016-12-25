class CreatePurchaseOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :purchase_orders do |t|
      t.integer    :company_id, null: false
      t.integer    :partner_id
      t.integer    :currency_id
      t.integer    :payment_method_id
      t.integer    :assignee_id
      t.integer    :bill_to_location_id
      t.integer    :ship_from_location_id
      t.integer    :ship_to_location_id
      t.integer    :line_items_count,        null: false, default: 0
      t.string     :order_number
      t.integer    :status,                  null: false, default: 0
      t.string     :email
      t.integer    :return_status,           null: false, default: 0
      t.integer    :tax_treatment,           null: false, default: 0
      t.integer    :total_units
      t.decimal    :subtotal,     precision: 12, scale: 2
      t.decimal    :total_tax,    precision: 12, scale: 2
      t.decimal    :total_amount, precision: 12, scale: 2
      t.date       :paid_on
      t.date       :expected_delivery_date
      t.text       :notes
      t.jsonb      :extra_info

      t.timestamps
    end

    add_index :purchase_orders, [:company_id, :partner_id]
    add_index :purchase_orders, :order_number
  end
end
