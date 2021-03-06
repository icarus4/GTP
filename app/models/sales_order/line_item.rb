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
#  shipment_status      :integer          default("unshipped"), not null
#  shipped_quantity     :integer          default(0), not null
#  invoiced_quantity    :integer
#  uninvoiced_quantity  :integer
#  invoice_status       :integer
#
# Indexes
#
#  index_sales_order_line_items_on_item_id         (item_id)
#  index_sales_order_line_items_on_sales_order_id  (sales_order_id)
#

class SalesOrder::LineItem < ApplicationRecord
  # Column notes
  # quantity:             user 指定的出貨數量
  # committed_quantity:   尚未出貨但已經在line_item_commitments中指定出貨貨源的數量
  # uncommitted_quantity: 尚未出貨也尚未指定出貨貨源的數量
  # shipped_quantity:     已出貨的數量
  # quantity = shipped_quantity + committed_quantity + uncommitted_quantity

  before_validation :setup_defaults
  before_save :calculate_total
  before_save :calculate_quantities, if: :quantity_changed?
  after_save :update_sales_order_shipment_status!, if: :shipment_status_changed?
  after_save :update_sales_order_totals!
  after_destroy :update_sales_order_totals!, :update_sales_order_shipment_status!

  belongs_to :sales_order, counter_cache: true
  belongs_to :item

  has_many :line_item_commitments, dependent: :destroy
  has_many :invoice_line_items,    dependent: :destroy

  validates :sales_order_id, presence: true
  validates :item_id,        presence: true
  validates :quantity,       presence: true, numericality: { greater_than_or_equal_to: 1 }
  validates :committed_quantity,   numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :uncommitted_quantity, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :shipped_quantity,     numericality: { greater_than_or_equal_to: 0 } # Always starts at 0, therefore allow_nil is not necessary
  validates :invoiced_quantity,    numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :uninvoiced_quantity,  numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  delegate :sku, :name, to: :item

  enum shipment_status: { unshipped: 0,  partial: 1, shipped: 2 },  _prefix: :shipment_status_is
  enum invoice_status: { uninvoiced: 0,  partial: 1, invoiced: 2 },  _prefix: :invoice_status_is

  def update_quantities!
    calculate_quantities
    save!
  end

  def update_shipment_status!
    if shipped_quantity == quantity
      shipment_status_is_shipped!
    elsif shipped_quantity == 0
      shipment_status_is_unshipped!
    else
      shipment_status_is_partial!
    end

    sales_order.update_status!
  end

  def update_invoice_related_columns!
    self.invoiced_quantity   = invoice_line_items.sum(:quantity)
    self.uninvoiced_quantity = quantity - invoiced_quantity
    update_invoice_status
    # changed is a built-in method
    _changed = invoiced_quantity_changed? || uninvoiced_quantity_changed? || invoice_status_changed?
    save!
    sales_order.update_invoice_related_columns! if _changed
  end

  private

    def calculate_total
      self.total = quantity * unit_price
    end

    def calculate_quantities
      self.shipped_quantity     = line_item_commitments.shipped.sum(:quantity)
      self.committed_quantity   = line_item_commitments.unshipped.sum(:quantity)
      self.uncommitted_quantity = quantity - shipped_quantity - committed_quantity
      self.invoiced_quantity    = invoice_line_items.sum(:quantity)
      self.uninvoiced_quantity  = quantity - invoiced_quantity
    end

    def setup_defaults
      self.committed_quantity ||= 0 if has_attribute?(:committed_quantity)
      self.invoice_status     ||= 'uninvoiced'
    end

    def update_sales_order_totals!
      sales_order.calculate_totals!
    end

    def update_sales_order_shipment_status!
      sales_order.update_shipment_status!
    end

    def update_invoice_status
      if invoiced_quantity == quantity
        self.invoice_status = 'invoiced'
      elsif invoiced_quantity == 0
        self.invoice_status = 'uninvoiced'
      elsif invoiced_quantity > 0 && invoiced_quantity < quantity
        self.invoice_status = 'partial'
      else
        raise "Shouldn't be here"
      end
    end
end
