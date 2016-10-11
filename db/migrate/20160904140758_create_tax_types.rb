class CreateTaxTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :tax_types do |t|
      t.references :company, null: false, index: true
      t.decimal    :percentage, null: false, precision: 4, scale: 1
      t.decimal    :rate,       null: false, precision: 4, scale: 3
      t.string     :name, null: false

      t.timestamps
    end
  end
end
