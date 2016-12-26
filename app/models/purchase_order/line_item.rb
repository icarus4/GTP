# == Schema Information
#
# Table name: purchase_order_line_items
#
#  id                  :integer          not null, primary key
#  purchase_order_id   :integer          not null
#  procurement_id      :integer
#  item_id             :integer          not null
#  variant_id          :integer
#  bin_location_id     :integer
#  location_variant_id :integer
#  quantity            :integer          not null
#  unit_price          :decimal(10, 2)   not null
#  tax_rate            :decimal(4, 1)
#  tax                 :decimal(10, 2)
#  total               :decimal(12, 2)   not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  returned_quantity   :integer          default(0), not null
#
# Indexes
#
#  index_purchase_order_line_items_on_bin_location_id      (bin_location_id)
#  index_purchase_order_line_items_on_item_id              (item_id)
#  index_purchase_order_line_items_on_location_variant_id  (location_variant_id)
#  index_purchase_order_line_items_on_procurement_id       (procurement_id)
#  index_purchase_order_line_items_on_purchase_order_id    (purchase_order_id)
#  index_purchase_order_line_items_on_variant_id           (variant_id)
#

class PurchaseOrder::LineItem < ApplicationRecord
  before_save :calculate_total
  after_save :update_purchase_order_return_status!, if: :procurement_id_changed?
  after_destroy :update_purchase_order_return_status!, if: :procurement_id_changed?

  belongs_to :purchase_order, counter_cache: :line_items_count
  belongs_to :procurement
  belongs_to :item
  belongs_to :variant
  belongs_to :bin_location
  belongs_to :location_variant

  has_many :purchase_order_return_line_items

  validates :purchase_order_id, presence: true
  validates :item_id,  presence: true
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 1 }
  validates :tax_rate, numericality: { greater_than_or_equal_to: 0 }
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :unprocured, -> { where(procurement_id: nil) }
  scope :procured, -> { where.not(procurement_id: nil) }
  scope :returnable, -> { where("quantity > returned_quantity") }

  # 當 PurchaseOrderReturnLineItem 產生時執行此 method
  def update_returned_quantity!
    self.returned_quantity = purchase_order_return_line_items.sum(:quantity)
    save!
  end

  private

    def calculate_total
      self.total = quantity * unit_price
    end

    def update_purchase_order_return_status!
      purchase_order.update_return_status!
    end
end
