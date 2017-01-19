class AddQuantityRelatedCacheColumnsToItemsAndVariants < ActiveRecord::Migration[5.0]
  def up
    add_column :variants, :committed_quantity, :integer, default: 0, null: false
    add_column :variants, :sellable_quantity,  :integer, default: 0, null: false
    add_column :items,    :quantity,           :integer, default: 0, null: false
    add_column :items,    :committed_quantity, :integer, default: 0, null: false
    add_column :items,    :sellable_quantity,  :integer, default: 0, null: false

    LocationVariant.where(committed_quantity: nil).update_all(committed_quantity: 0)
    LocationVariant.where(sellable_quantity: nil).update_all(sellable_quantity: 0)

    change_column_default :location_variants, :committed_quantity, 0
    change_column_default :location_variants, :sellable_quantity, 0
    change_column_null    :location_variants, :sellable_quantity, false

    LocationVariant.find_each { |lv| lv.update_quantities! }
    Variant.find_each { |v| v.update_cache_columns! }
    Item.find_each { |i| i.update_cache_columns! }
  end

  def down
    remove_column :variants, :committed_quantity
    remove_column :variants, :sellable_quantity
    remove_column :items,    :committed_quantity
    remove_column :items,    :sellable_quantity
    remove_column :items,    :quantity
    change_column_null    :location_variants, :sellable_quantity, true
    change_column_default :location_variants, :sellable_quantity, nil
    change_column_default :location_variants, :committed_quantity, nil
  end
end
