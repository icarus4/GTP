class CreateBinLocations < ActiveRecord::Migration
  def change
    create_table :bin_locations do |t|
      t.references :location, null: false
      t.string     :name

      t.timestamps null: false
    end
  end
end
