class CreateVariants < ActiveRecord::Migration
  def change
    create_table :variants do |t|
      t.references :item,            null: false, index: true
      t.integer    :quantity,        null: false, default: 0
      t.date       :manufacturing_date
      t.date       :expiry_date,                                     index: true
      t.string     :import_admitted_notice_number, limit: 255,       index: true
      t.string     :goods_declaration_number,      limit: 255,       index: true
      t.string     :item_number,                   limit: 255
      t.string     :lot_number,                    limit: 255

      t.timestamps null: false
    end
  end
end
