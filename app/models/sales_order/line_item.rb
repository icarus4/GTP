# == Schema Information
#
# Table name: sales_order_line_items
#
#  id             :integer          not null, primary key
#  sales_order_id :integer          not null
#  item_id        :integer          not null
#  quantity       :integer          not null
#  unit_price     :decimal(10, 2)   not null
#  tax_rate       :decimal(4, 1)
#  tax            :decimal(10, 2)
#  total          :decimal(12, 2)   not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_sales_order_line_items_on_item_id         (item_id)
#  index_sales_order_line_items_on_sales_order_id  (sales_order_id)
#

class SalesOrder::LineItem < ApplicationRecord
  before_save :calculate_total

  belongs_to :sales_order
  belongs_to :item
  belongs_to :variant
  belongs_to :bin_location
  belongs_to :location_variant

  has_many :line_item_commitments

  private

    def calculate_total
      self.total = quantity * unit_price
    end
end
