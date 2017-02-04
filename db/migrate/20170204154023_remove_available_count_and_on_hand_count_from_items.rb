class RemoveAvailableCountAndOnHandCountFromItems < ActiveRecord::Migration[5.0]
  def change
    remove_column :items, :on_hand_count, :integer, default: 0, null: false
    remove_column :items, :available_count, :integer, default: 0, null: false
  end
end
