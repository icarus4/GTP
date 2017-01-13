# == Schema Information
#
# Table name: location_variants
#
#  id                 :integer          not null, primary key
#  company_id         :integer
#  bin_location_id    :integer
#  variant_id         :integer
#  quantity           :integer          default(0), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  location_id        :integer
#  item_id            :integer
#  expiry_date        :date
#  committed_quantity :integer          not null
#  sellable_quantity  :integer
#
# Indexes
#
#  index_location_variants_on_bin_location_id  (bin_location_id)
#  index_location_variants_on_company_id       (company_id)
#  index_location_variants_on_quantity         (quantity)
#  index_location_variants_on_variant_id       (variant_id)
#

class LocationVariant < ActiveRecord::Base
  # NOTICE:
  # 1.
  # 此 model 的 foreign key 只需要 assign bin_location_id 與 variant_id
  # 其餘 foreign_key 交由 setup_denormalized_columns 設置，請勿手動設置
  #
  # 2.
  # column 解釋
  # quantity: 倉庫目前的數量
  # committed_quantity: 準備未來要出貨的數量 (被尚未出貨的 sales order 所保留下來的數量)
  # sellable_quantity: 可被新的出貨單所出貨的數量 (sellable_quantity = quantity - committed_quantity)


  before_validation :setup_denormalized_columns
  before_save :calculate_quantities, if: :quantity_changed?
  after_save :update_variant_cache_columns!
  after_initialize :setup_defaults

  belongs_to :company
  belongs_to :location
  belongs_to :bin_location
  belongs_to :item
  belongs_to :variant

  has_many :sales_order_line_item_commitments, class_name: 'SalesOrder::LineItemCommitment'

  validates :company_id, :variant_id, :quantity, presence: true
  validates :bin_location_id, presence: true, uniqueness: { scope: :variant_id }
  validates :quantity, presence: true
  validates :committed_quantity, numericality: { greater_than_or_equal_to: 0 }
  validates :sellable_quantity, numericality: true

  # 預設的出貨順序:
  # 1. 必須有貨可出 (sellable_quantity > 0)
  # 2. 無 expiry_date 先出貨，其次越快過期的越早出貨
  # 2.
  # WARNING: order with "NULLS FIRST/LAST" is PostgreSQL only syntax
  scope :default_sales_committed_sequence, -> { where("sellable_quantity > 0").order("expiry_date ASC NULLS FIRST") }

  def update_quantities!
    calculate_quantities
    save!
  end

  # Ship sales order committed line items 時，須根據 committed line item 的數量來扣減 quantity
  def change_quantity_by_shipping_committed_line_item!(sales_order_line_item_commitment)
    self.quantity -= sales_order_line_item_commitment.quantity
    save!
  end

  private

    def update_variant_cache_columns!
      variant.update_cache_columns!
    end

    def setup_defaults
      self.quantity           ||= 0
      self.committed_quantity ||= 0
      self.sellable_quantity  ||= 0
    end

    def setup_denormalized_columns
      self.location_id = bin_location.location_id if bin_location_id_changed?
      self.item_id     = variant.item_id          if variant_id_changed?
      self.expiry_date = variant.expiry_date      if variant_id_changed?
    end

    def calculate_quantities
      self.committed_quantity = sales_order_line_item_commitments.unshipped.sum(:quantity)
      self.sellable_quantity  = quantity - committed_quantity
    end
end
