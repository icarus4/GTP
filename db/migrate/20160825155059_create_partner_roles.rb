class CreatePartnerRoles < ActiveRecord::Migration
  def change
    create_table :partner_roles do |t|
      t.string :name, null: false
      t.timestamps null: false
    end
  end
end
