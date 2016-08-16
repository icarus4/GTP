class CreatePackagingTypes < ActiveRecord::Migration
  def change
    create_table :packaging_types do |t|
      t.references :company, index: true, null: true, foreign_key: true
      t.string     :name
      t.string     :code

      t.timestamps null: false
    end

    PackagingType::CODE_NAME_MAPPING.each do |code, name|
      pt = PackagingType.find_or_initialize_by(company_id: nil, name: name)
      pt.code = code
      pt.save!
    end
  end
end
