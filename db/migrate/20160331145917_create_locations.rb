class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.references :locationable, polymorphic: true, index: true
      t.references :city
      t.string     :zip,     limit: 8
      t.string     :phone,   limit: 32
      t.string     :email,   limit: 64
      t.string     :address, limit: 255
      t.string     :name,    limit: 255
      t.boolean    :holds_stock, null: false, default: false

      t.timestamps null: false
    end
  end
end
