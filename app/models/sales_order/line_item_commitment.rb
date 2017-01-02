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
#  shipment_id         :integer
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
#  index_sales_order_line_item_commitments_on_shipment_id      (shipment_id)
#  index_sales_order_line_item_commitments_on_variant_id       (variant_id)
#

class SalesOrder::LineItemCommitment < ApplicationRecord
  # NOTICE:
  # 此 model 的 foreign key 只需要 assign location_variant_id 與 line_item_id，其餘 foreign_key
  # 其餘 foreign_key 交由 setup_denormalized_columns 設置，請勿手動設置

  before_validation :setup_denormalized_columns
  after_save :update_associations_quantities!

  belongs_to :line_item
  belongs_to :location_variant
  belongs_to :location
  belongs_to :variant
  belongs_to :item

  validates :line_item_id,
            :bin_location_id,
            :location_id,
            :location_variant_id,
            :variant_id,
            :item_id,
            presence: true

  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  scope :unshipped, -> { where(shipment_id: nil) }

  private

    def setup_denormalized_columns
      self.bin_location_id = location_variant.bin_location_id          if location_variant_id_changed?
      self.location_id     = location_variant.bin_location.location_id if location_variant_id_changed?
      self.variant_id      = location_variant.variant_id               if location_variant_id_changed?
      self.item_id         = line_item.item_id                         if line_item_id_changed?
    end

    def update_associations_quantities!
      location_variant.update_quantities!
      line_item.update_quantities!
    end
end
