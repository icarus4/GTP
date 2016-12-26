# == Schema Information
#
# Table name: sales_order_line_items
#
#  id                  :integer          not null, primary key
#  sales_order_id      :integer          not null
#  shipment_id         :integer
#  item_id             :integer          not null
#  variant_id          :integer
#  bin_location_id     :integer
#  location_variant_id :integer
#  quantity            :integer          not null
#  unit_price          :decimal(10, 2)   not null
#  tax_rate            :decimal(4, 1)
#  tax                 :decimal(10, 2)
#  total               :decimal(12, 2)   not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_sales_order_line_items_on_item_id         (item_id)
#  index_sales_order_line_items_on_sales_order_id  (sales_order_id)
#  index_sales_order_line_items_on_shipment_id     (shipment_id)
#  index_sales_order_line_items_on_variant_id      (variant_id)
#

class SalesOrder::LineItem < ApplicationRecord
  belongs_to :sales_order
  belongs_to :item
  belongs_to :variant
  belongs_to :bin_location
  belongs_to :location_variant
end
