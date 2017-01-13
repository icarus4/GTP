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

class SalesOrder::Shipment < ApplicationRecord
  belongs_to :sales_order
  before_save :setup_shipped_on

  validates :sales_order_id, presence: true

  private

    def setup_shipped_on
      self.shipped_on = shipped_at.to_date if shipped_at
    end
end
