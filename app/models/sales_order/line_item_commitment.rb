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

class SalesOrder::LineItemCommitment < ApplicationRecord
  belongs_to :line_item
  belongs_to :location_variant, foreign_key: :bin_location_id
  belongs_to :location
  belongs_to :variant
  belongs_to :item

  validates :line_item_id,
            :bin_location_id,
            :location_id,
            :bin_location_variant_id,
            :variant_id,
            :item_id,
            presence: true

  validates :quantity, presence: true, numericality: { greater_or_equal_than: 0, only_integer: true }
end
