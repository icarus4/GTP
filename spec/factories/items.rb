# == Schema Information
#
# Table name: items
#
#  id                    :integer          not null, primary key
#  company_id            :integer          not null
#  item_series_id        :integer
#  packaging_type_id     :integer
#  cost_per_unit         :decimal(10, 2)
#  purchase_price        :decimal(10, 2)
#  wholesale_price       :decimal(10, 2)
#  retail_price          :decimal(10, 2)
#  low_stock_alert_level :integer
#  status                :integer          default("active"), not null
#  weight_unit           :integer
#  weight_value          :decimal(10, 2)
#  manufactured_by_self  :boolean          default(FALSE), not null
#  expirable             :boolean          default(TRUE), not null
#  sellable              :boolean          default(TRUE), not null
#  purchasable           :boolean          default(TRUE), not null
#  image                 :string
#  sku                   :string
#  sku_from_supplier     :string
#  name                  :string           default(""), not null
#  description           :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  quantity              :integer          default(0), not null
#  committed_quantity    :integer          default(0), not null
#  sellable_quantity     :integer          default(0), not null
#
# Indexes
#
#  index_items_on_company_id      (company_id)
#  index_items_on_item_series_id  (item_series_id)
#  index_items_on_name            (name)
#  index_items_on_sku             (sku)
#

FactoryGirl.define do
  factory :item do
    company { Company.first || create(:company) }
    supplier
    item_type
    brand
    unit { ['包', '箱', '個'].sample }
    sellable_quantity { 0 }
    quantity { 0 }
    name { FFaker::Product.product }
  end
end
