# == Schema Information
#
# Table name: sales_order_line_item_commitments
#
#  id                  :integer          not null, primary key
#  line_item_id        :integer
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
#  index_line_item_commitments_on_location_variant_id       (location_variant_id)
#  index_sales_order_line_item_commitments_on_item_id       (item_id)
#  index_sales_order_line_item_commitments_on_line_item_id  (line_item_id)
#  index_sales_order_line_item_commitments_on_location_id   (location_id)
#  index_sales_order_line_item_commitments_on_shipment_id   (shipment_id)
#  index_sales_order_line_item_commitments_on_variant_id    (variant_id)
#

class SalesOrder::LineItemCommitment < ApplicationRecord
  # NOTICE:
  # 此 model 的 foreign key 只需要 assign location_variant_id 與 line_item_id，
  # 其餘 foreign_key 交由 setup_denormalized_columns 設置，請勿手動設置

  before_validation :setup_denormalized_columns
  after_save :update_associations_quantities!, :update_line_item_shipment_status!
  before_destroy :undo_shipping!, if: :shipped?
  after_destroy :update_associations_quantities! # after_destroy 不執行 update_line_item_shipment_status!，因為要保留 void 前 sales order 與 line_item 的 status

  belongs_to :line_item
  belongs_to :location_variant
  belongs_to :location
  belongs_to :variant
  belongs_to :item
  belongs_to :shipment

  delegate :unit_price, :tax_rate, :total, to: :line_item
  delegate :sku, :name, to: :item

  validates :line_item_id,
            :location_id,
            :location_variant_id,
            :variant_id,
            :item_id,
            presence: true

  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  scope :unshipped, -> { where(shipment_id: nil) }
  scope :shipped,   -> { where.not(shipment_id: nil) }

  # Ship item
  # 執行此 method 會讓對應的 location variant 改變數量
  def ship!(shipment)
    raise 'Already shipped' if shipped?
    raise ArgumentError, 'Wrong shipment type' if !shipment.is_a?(SalesOrder::Shipment)
    raise 'Sales order not matched' if shipment.sales_order_id != line_item.sales_order_id
    raise 'Shipment should be persisted' if !shipment.persisted?

    # LocationVariant#change_quantity_by_shipping_committed_line_item! 會檢查 line_item_commitment 是否已經ship(透過檢查shipment_id)
    # 因此要先執行LocationVariant#decrease_quantity_by_shipping_committed_line_item!, 再執行update_columns(shipment_id: shipment.id, updated_at: Time.zone.now)
    ActiveRecord::Base.transaction do
      # FIXME: location variant的quanity計算方式目前為針對現有commitment的數量做加減
      #        此方法有一個潛在缺點就是若此method執行數次，會導致location variant的quantity被重複扣減，然而理應只被扣減一次
      #        目前利用檢查 shipment_id.present? 來避免被重複扣減。
      #        之後應改為透過加減各項相關數據得到的一個deterministic的quantity(不管被執行幾次，都應該算出正確的quantity)
      location_variant.decrease_quantity_by_shipping_committed_line_item!(self)

      update!(shipment_id: shipment.id) # Use #update_columns to avoid triggering callbacks
    end
  end

  def undo_shipping!
    return nil if unshipped?
    location_variant.increase_quantity_by_reverting_shipping_committed_line_item!(self)
    update!(shipment_id: nil)
  end

  def shipped?
    shipment_id.present?
  end

  def unshipped?
    shipment_id.nil?
  end

  private

    def setup_denormalized_columns
      self.location_id     = location_variant.location_id if location_variant_id_changed?
      self.variant_id      = location_variant.variant_id  if location_variant_id_changed?
      self.item_id         = line_item.item_id            if line_item_id_changed?
    end

    def update_line_item_shipment_status!
      line_item.update_shipment_status! if shipment_id_changed?
    end

    def update_associations_quantities!
      location_variant.update_quantities!
      line_item.update_quantities!
    end
end
