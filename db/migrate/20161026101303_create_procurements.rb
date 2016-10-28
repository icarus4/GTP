class CreateProcurements < ActiveRecord::Migration[5.0]
  def change
    create_table :procurements do |t|
      t.references :purchase_order, null: false, index: true
      t.datetime   :received_at

      t.timestamps
    end
  end
end
