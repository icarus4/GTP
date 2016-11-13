class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.references :company, null: false
      t.references :partner
      t.integer    :currency_id
      t.integer    :payment_method_id
      t.integer    :assignee_id,             index: true
      t.integer    :bill_to_location_id
      t.integer    :ship_from_location_id
      t.integer    :ship_to_location_id
      t.integer    :line_items_count,        null: false, default: 0
      t.string     :type,                    index: true
      t.string     :order_number,            index: true
      t.string     :state,                   index: true
      t.string     :status,                  index: true
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
  end
end
