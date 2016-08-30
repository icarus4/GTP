class CreatePartnerRelationships < ActiveRecord::Migration
  def change
    create_table :partner_relationships do |t|
      t.references :partner, null: false, foreign_key: true
      t.references :partner_role, null: false, foreign_key: true

      t.timestamps null: false
    end

    add_index :partner_relationships, [:partner_id, :partner_role_id], unique: true
  end
end
