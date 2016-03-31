class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.references :locationable, polymorphic: true, index: true
      t.references :city
      t.string     :zip,     limit: 8
      t.string     :address, limit: 255
      t.string     :name,    limit: 255
      t.boolean    :holds_stock, default: true

      t.timestamps null: false
    end
  end
end
