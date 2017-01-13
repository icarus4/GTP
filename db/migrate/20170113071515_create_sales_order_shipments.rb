class CreateSalesOrderShipments < ActiveRecord::Migration[5.0]
  def change
    create_table :sales_order_shipments do |t|
      t.references :sales_order, index: true
      t.datetime   :shipped_at
      t.date       :shipped_on

      t.timestamps
    end
  end
end
