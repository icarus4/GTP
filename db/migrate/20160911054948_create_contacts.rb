class CreateContacts < ActiveRecord::Migration[5.0]
  def change
    create_table :contacts do |t|
      t.references :contactable, polymorphic: true, index: true
      t.string     :name, null: false
      t.string     :title
      t.string     :phone
      t.string     :mobile
      t.string     :fax
      t.string     :email
      t.string     :department
      t.text       :notes

      t.timestamps
    end
  end
end
