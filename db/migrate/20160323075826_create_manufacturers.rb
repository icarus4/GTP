class CreateManufacturers < ActiveRecord::Migration
  def change
    create_table :manufacturers do |t|
      t.references :company, index: true, foreign_key: true
      t.integer    :location_type, limit: 1
      t.string     :name
      t.string     :registration_number
      t.string     :address
    end
  end
end
