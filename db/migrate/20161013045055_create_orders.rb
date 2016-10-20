class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.references :company, null: false
      t.references :partner
      t.integer    :currency_id
      t.integer    :payment_method_id
      t.string     :type,                    index: true
      t.integer    :assignee_id,             index: true
      t.integer    :bill_to_location_id
      t.integer    :ship_from_location_id
      t.integer    :ship_to_location_id
      t.string     :order_number,            index: true
      t.string     :state,                   index: true
      t.string     :status,                  index: true
      t.integer    :tax_treatment,           null: false, default: 0
      t.integer    :total_units
      t.decimal    :total_amount, precision: 12, scale: 2
      t.date       :paid_on
      t.date       :expected_delivery_date
      t.text       :notes
      t.jsonb      :extra_info

      t.timestamps
    end
  end
end
