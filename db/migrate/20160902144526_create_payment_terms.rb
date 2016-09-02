class CreatePaymentTerms < ActiveRecord::Migration[5.0]
  def change
    create_table :payment_terms do |t|
      t.references :company, null: false, foreign_key: true, index: true
      t.string     :name, null: false
      t.integer    :due_in_days, null: false
      t.integer    :start_from,  null: false

      t.timestamps
    end
  end
end
