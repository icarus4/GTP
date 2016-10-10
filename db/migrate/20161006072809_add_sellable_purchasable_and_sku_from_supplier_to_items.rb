class AddSellablePurchasableAndSkuFromSupplierToItems < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :sellable, :boolean
    add_column :items, :purchasable, :boolean
    add_column :items, :sku_from_supplier, :string
  end
end
