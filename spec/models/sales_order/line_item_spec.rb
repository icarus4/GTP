# == Schema Information
#
# Table name: sales_order_line_items
#
#  id                   :integer          not null, primary key
#  sales_order_id       :integer          not null
#  item_id              :integer          not null
#  quantity             :integer          not null
#  committed_quantity   :integer          not null
#  uncommitted_quantity :integer          not null
#  unit_price           :decimal(10, 2)   not null
#  tax_rate             :decimal(4, 1)
#  tax                  :decimal(10, 2)
#  total                :decimal(12, 2)   not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  shipment_status      :integer          default("unshipped"), not null
#  shipped_quantity     :integer          default(0), not null
#  invoiced_quantity    :integer
#  uninvoiced_quantity  :integer
#  invoice_status       :integer
#
# Indexes
#
#  index_sales_order_line_items_on_item_id         (item_id)
#  index_sales_order_line_items_on_sales_order_id  (sales_order_id)
#

require 'rails_helper'

RSpec.describe SalesOrder::LineItem, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
