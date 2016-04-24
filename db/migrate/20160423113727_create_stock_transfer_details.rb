class CreateStockTransferDetails < ActiveRecord::Migration
  def change
    create_table :stock_transfer_details do |t|
      t.references :stock_transfer, index: true
      t.references :variant
      t.integer    :quantity

      t.timestamps null: false
    end
  end
end
