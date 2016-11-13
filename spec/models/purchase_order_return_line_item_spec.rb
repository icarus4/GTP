# == Schema Information
#
# Table name: purchase_order_return_line_items
#
#  id                       :integer          not null, primary key
#  purchase_order_return_id :integer          not null
#  line_item_id             :integer          not null
#  item_id                  :integer          not null
#  quantity                 :integer          not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
# Indexes
#
#  index_por_line_items_on_purchase_order_return_id        (purchase_order_return_id)
#  index_purchase_order_return_line_items_on_item_id       (item_id)
#  index_purchase_order_return_line_items_on_line_item_id  (line_item_id)
#

require 'rails_helper'

RSpec.describe PurchaseOrderReturnLineItem, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
