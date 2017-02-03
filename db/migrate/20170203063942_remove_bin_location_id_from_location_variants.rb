class RemoveBinLocationIdFromLocationVariants < ActiveRecord::Migration[5.0]
  def change
    remove_column :location_variants, :bin_location_id, :integer, index: true
  end
end
