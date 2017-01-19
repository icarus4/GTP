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
  before_save :setup_shipped_on
  before_destroy :revert_line_item_commitments_shipping!

  belongs_to :sales_order
  has_many :line_item_commitments

  validates :sales_order_id, presence: true

  private

    def revert_line_item_commitments_shipping!
      line_item_commitments.each(&:undo_shipping!)
    end

    def setup_shipped_on
      self.shipped_on = shipped_at.to_date if shipped_at
    end
end
