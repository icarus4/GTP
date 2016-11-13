class AddReturnStatusToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :return_status, :integer, null: false, default: 0
  end
end
