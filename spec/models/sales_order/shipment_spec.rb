# == Schema Information
#
# Table name: sales_order_shipments
#
#  id             :integer          not null, primary key
#  sales_order_id :integer
#  shipped_at     :datetime
#  shipped_on     :date
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_sales_order_shipments_on_sales_order_id  (sales_order_id)
#

require 'rails_helper'

RSpec.describe SalesOrder::Shipment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
