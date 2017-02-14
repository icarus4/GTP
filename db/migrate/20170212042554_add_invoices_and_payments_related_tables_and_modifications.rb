class AddInvoicesAndPaymentsRelatedTablesAndModifications < ActiveRecord::Migration[5.0]
  def change
    # Invoice
    create_table :sales_order_invoices do |t|
      t.integer :sales_order_id, null: false, index: true
      t.integer :payment_term_id,             index: true
      t.date    :invoiced_on
      t.date    :due_on,                      index: true
      t.integer :payment_status,  null: false
      t.integer :total_units
      t.decimal :total_amount,  precision: 12, scale: 2
      t.decimal :paid_amount,   precision: 12, scale: 2
      t.decimal :unpaid_amount, precision: 12, scale: 2
      t.text    :notes

      t.timestamps null: false
    end

    create_table :sales_order_invoice_line_items do |t|
      t.integer :invoice_id,   null: false, index: true
      t.integer :line_item_id, null: false, index: true
      t.integer :quantity, null: false

      t.timestamps null: false
    end

    create_table :sales_order_payments do |t|
      t.integer :invoice_id,        null: false, index: true
      t.integer :payment_method_id,              index: true
      t.decimal :amount,            precision: 12, scale: 2
      t.string  :transfer_out_account
      t.string  :transfer_in_account

      t.timestamps null: false
    end

    add_column :sales_orders, :invoiced_quantity,       :integer
    add_column :sales_orders, :uninvoiced_quantity,     :integer
    add_column :sales_orders, :invoiced_total_amount,   :decimal, precision: 12, scale: 2
    add_column :sales_orders, :uninvoiced_total_amount, :decimal, precision: 12, scale: 2
    add_column :sales_orders, :paid_total_amount,       :decimal, precision: 12, scale: 2
    add_column :sales_orders, :unpaid_total_amount,     :decimal, precision: 12, scale: 2

    add_column :sales_order_line_items, :invoiced_quantity,   :integer
    add_column :sales_order_line_items, :uninvoiced_quantity, :integer
    add_column :sales_order_line_items, :invoice_status,      :integer

    SalesOrder::LineItem.find_each do |line_item|
      line_item.update_invoice_related_columns!
    end
  end
end
