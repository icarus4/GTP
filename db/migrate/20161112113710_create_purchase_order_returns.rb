class CreatePurchaseOrderReturns < ActiveRecord::Migration[5.0]
  def change
    create_table :purchase_order_returns do |t|
      t.references :company
      t.references :purchase_order
      t.string     :order_number,   index: true
      t.text       :notes

      t.timestamps
    end
  end
end
