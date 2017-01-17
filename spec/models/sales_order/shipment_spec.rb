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
  describe 'when destroyed' do
    xit '回復庫存' do
    end

    xit "changes sales order's shipment_status to unshipped" do
    end
  end
end
