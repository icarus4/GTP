# == Schema Information
#
# Table name: order_line_items
#
#  id         :integer          not null, primary key
#  order_id   :integer          not null
#  item_id    :integer          not null
#  variant_id :integer
#  quantity   :integer          not null
#  unit_price :decimal(10, 2)   not null
#  tax_rate   :decimal(4, 1)
#  tax        :decimal(10, 2)
#  total      :decimal(12, 2)   not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_order_line_items_on_item_id     (item_id)
#  index_order_line_items_on_order_id    (order_id)
#  index_order_line_items_on_variant_id  (variant_id)
#

class Order::LineItem < ApplicationRecord
  belongs_to :order, counter_cache: true
  belongs_to :purchase_order, foreign_key: :order_id
  belongs_to :item
  belongs_to :variant

  validates :order_id, presence: true
  validates :item_id,  presence: true
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 1 }
  validates :tax_rate, numericality: { greater_than_or_equal_to: 0 }
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  before_save :calculate_total

  private

    def calculate_total
      self.total = quantity * unit_price
    end
end
