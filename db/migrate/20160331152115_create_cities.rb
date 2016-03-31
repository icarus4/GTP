class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name, limit: 32, index: true, null: false

      t.datetime :created_at
    end
  end
end
