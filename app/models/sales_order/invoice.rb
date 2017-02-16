# == Schema Information
#
# Table name: sales_order_invoices
#
#  id              :integer          not null, primary key
#  sales_order_id  :integer          not null
#  payment_term_id :integer
#  invoiced_on     :date
#  due_on          :date
#  payment_status  :integer          not null
#  total_units     :integer
#  total_amount    :decimal(12, 2)
#  paid_amount     :decimal(12, 2)
#  unpaid_amount   :decimal(12, 2)
#  notes           :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_sales_order_invoices_on_due_on           (due_on)
#  index_sales_order_invoices_on_payment_term_id  (payment_term_id)
#  index_sales_order_invoices_on_sales_order_id   (sales_order_id)
#

class SalesOrder::Invoice < ApplicationRecord
  after_initialize :setup_defaults
  after_save    :update_sales_order!
  after_destroy :update_sales_order!

  belongs_to :sales_order
  belongs_to :payment_term

  has_many :invoice_line_items, dependent: :destroy
  has_many :payments,           dependent: :destroy

  validates :sales_order_id,  presence: true
  validates :payment_term_id, presence: true
  validates :total_units, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  auto_strip_attributes :notes

  enum payment_status: { unpaid:  0, partial: 1, paid: 2 }, _prefix: :payment_status_is

  def invoice_all!
    ActiveRecord::Base.transaction do
      # Create invoice line items
      sales_order.line_items.each do |line_item|
        self.invoice_line_items.create!(
          line_item_id: line_item.id,
          quantity:     line_item.uninvoiced_quantity || line_item.quantity
        )
      end
      # Update self
      self.total_amount = sales_order.total_amount
      self.total_units  = sales_order.total_units
      update_payment_related_columns
      save!
    end
  end

  # payment 有變動時執行此 method
  def update_payment_related_columns!
    update_payment_related_columns
    save!
  end

  private

    def update_sales_order!
      sales_order.update_invoice_related_columns!
    end

    def update_payment_related_columns
      self.paid_amount    = payments.sum(:amount)
      self.unpaid_amount  = total_amount - paid_amount
      self.payment_status = if paid_amount == 0
                              'unpaid'
                            elsif unpaid_amount == 0
                              'paid'
                            else
                              'partial'
                            end
    end

    def setup_defaults
      self.payment_status ||= 'unpaid'
    end
end
