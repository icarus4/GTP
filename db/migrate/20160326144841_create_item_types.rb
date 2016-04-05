class CreateItemTypes < ActiveRecord::Migration
  def change
    create_table :item_types do |t|
      t.references :company, null: false
      t.string     :name,    null: false, limit: 255

      t.timestamps null: false
    end
  end
end
