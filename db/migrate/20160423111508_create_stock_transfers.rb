class CreateStockTransfers < ActiveRecord::Migration
  def change
    create_table :stock_transfers do |t|
      t.references :company, index: true, foreign_key: true
      t.references :source_location
      t.references :destination_location
      t.string     :status, limit: 32, null: false, index: true
      t.string     :order_number, limit: 64
      t.date       :expected_transfer_date
      t.datetime   :transferred_at

      t.timestamps null: false
    end

    add_foreign_key :stock_transfers, :locations, column: :source_location_id
    add_foreign_key :stock_transfers, :locations, column: :destination_location_id
  end
end
