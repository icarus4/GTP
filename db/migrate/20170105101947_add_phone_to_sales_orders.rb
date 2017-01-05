class AddPhoneToSalesOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :sales_orders, :phone, :string
  end
end
