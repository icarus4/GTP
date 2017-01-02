class AddLocationIdItemIdExpiryDateAndCommittedQuantityToLocationVariants < ActiveRecord::Migration[5.0]
  def up
    add_column :location_variants, :location_id,        :integer, index: true
    add_column :location_variants, :item_id,            :integer, index: true
    add_column :location_variants, :expiry_date,        :date,    index: true
    add_column :location_variants, :committed_quantity, :integer
    add_column :location_variants, :sellable_quantity,  :integer, index: true

    LocationVariant.find_each do |lv|
      lv.location_id        = lv.bin_location.location_id
      lv.item_id            = lv.variant.item_id
      lv.expiry_date        = lv.variant.expiry_date
      lv.save!
    end

    change_column_null :location_variants, :committed_quantity, false
  end

  def down
    remove_column :location_variants, :location_id
    remove_column :location_variants, :item_id
    remove_column :location_variants, :expiry_date
    remove_column :location_variants, :committed_quantity
    remove_column :location_variants, :sellable_quantity
  end
end
