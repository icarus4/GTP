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
#
# Indexes
#
#  index_sales_order_line_items_on_item_id         (item_id)
#  index_sales_order_line_items_on_sales_order_id  (sales_order_id)
#

class SalesOrder::LineItem < ApplicationRecord
  after_initialize :setup_defaults
  before_save :calculate_total
  before_save :calculate_quantities, if: :quantity_changed?

  belongs_to :sales_order
  belongs_to :item
  belongs_to :bin_location
  belongs_to :location_variant

  has_many :line_item_commitments

  validates :sales_order_id, presence: true
  validates :item_id,        presence: true
  validates :quantity,       presence: true, numericality: { greater_than_or_equal_to: 1 }
  validates :committed_quantity,   numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :uncommitted_quantity, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  def update_quantities!
    calculate_quantities
    save!
  end

  private

    def calculate_total
      self.total = quantity * unit_price
    end

    def calculate_quantities
      self.committed_quantity = line_item_commitments.unshipped.sum(:quantity)
      self.uncommitted_quantity = quantity - committed_quantity
    end

    def setup_defaults
      self.committed_quantity ||= 0 if has_attribute?(:committed_quantity)
    end
end
