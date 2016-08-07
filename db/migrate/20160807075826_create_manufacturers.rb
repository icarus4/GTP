class CreateManufacturers < ActiveRecord::Migration
  def change
    create_table :manufacturers do |t|
      t.references :company, index: true
      t.boolean    :foreign, null: false, default: false
      t.string     :name
      t.string     :registration_number
      t.string     :address
    end
  end
end
