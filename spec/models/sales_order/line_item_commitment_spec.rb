# == Schema Information
#
# Table name: sales_order_line_item_commitments
#
#  id                  :integer          not null, primary key
#  line_item_id        :integer
#  bin_location_id     :integer
#  location_id         :integer
#  location_variant_id :integer
#  variant_id          :integer
#  item_id             :integer
#  quantity            :integer          default(0), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_line_item_commitments_on_location_variant_id          (location_variant_id)
#  index_sales_order_line_item_commitments_on_bin_location_id  (bin_location_id)
#  index_sales_order_line_item_commitments_on_item_id          (item_id)
#  index_sales_order_line_item_commitments_on_line_item_id     (line_item_id)
#  index_sales_order_line_item_commitments_on_location_id      (location_id)
#  index_sales_order_line_item_commitments_on_variant_id       (variant_id)
#

require 'rails_helper'

RSpec.describe SalesOrder::LineItemCommitment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
