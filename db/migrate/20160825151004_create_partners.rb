class CreatePartners < ActiveRecord::Migration
  def change
    create_table :partners do |t|
      t.references :company,                     null: false, index: true, foreign_key: true
      t.integer    :partner_type,                null: false, default: 0
      t.integer    :location_type,               null: false, default: 0
      t.integer    :status,                      null: false, default: 0
      t.string     :name,            limit: 128, null: false, index: true
      t.string     :alias_name,      limit: 128,              index: true
      t.string     :email,           limit: 64
      t.string     :tax_number,      limit: 32
      t.string     :phone,           limit: 32
      t.string     :fax,             limit: 32
      t.string     :food_industry_register_number, limit: 64
      t.string     :factory_register_number,       limit: 64
      t.string     :website,                       limit: 255
      t.string     :no_register_number_reason,     limit: 255
      t.text       :description

      t.timestamps null: false
    end
  end
end