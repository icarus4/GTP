class CreateStockTransfers < ActiveRecord::Migration
  def change
    create_table :stock_transfers do |t|
      t.references :company, index: true
      t.references :source_location
      t.references :destination_location
      t.string     :status, limit: 32, null: false, index: true
      t.string     :order_number, limit: 64
      t.date       :expected_transfer_date
      t.datetime   :transferred_at

      t.timestamps null: false
    end
  end
end
