# == Schema Information
#
# Table name: order_line_items
#
#  id                  :integer          not null, primary key
#  order_id            :integer          not null
#  procurement_id      :integer
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
#  returned_quantity   :integer          default(0), not null
#
# Indexes
#
#  index_order_line_items_on_bin_location_id      (bin_location_id)
#  index_order_line_items_on_item_id              (item_id)
#  index_order_line_items_on_location_variant_id  (location_variant_id)
#  index_order_line_items_on_order_id             (order_id)
#  index_order_line_items_on_procurement_id       (procurement_id)
#  index_order_line_items_on_variant_id           (variant_id)
#

require 'rails_helper'

RSpec.describe Order::LineItem, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
