class CreatePaymentMethods < ActiveRecord::Migration[5.0]
  def change
    create_table :payment_methods do |t|
      t.references :company, null: false, index: true
      t.string     :name,    null: false

      t.timestamps
    end
  end
end
