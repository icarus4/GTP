# == Schema Information
#
# Table name: sales_order_payments
#
#  id                   :integer          not null, primary key
#  sales_order_id       :integer          not null
#  invoice_id           :integer          not null
#  payment_method_id    :integer
#  amount               :decimal(12, 2)
#  receipt_date         :date
#  transfer_out_account :string
#  transfer_in_account  :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_sales_order_payments_on_invoice_id         (invoice_id)
#  index_sales_order_payments_on_payment_method_id  (payment_method_id)
#  index_sales_order_payments_on_sales_order_id     (sales_order_id)
#

class SalesOrder::Payment < ApplicationRecord
  # sales_order_id 交由 #setup_denormalized_columns 自動填入
  before_validation :setup_denormalized_columns
  after_save    :update_invoice!
  after_destroy :update_invoice!

  belongs_to :sales_order
  belongs_to :invoice
  belongs_to :payment_method

  validates :sales_order_id, presence: true
  validates :invoice_id, presence: true
  validates :receipt_date, presence: true
  validates :transfer_out_account, length: { maximum: 32 }
  validates :transfer_in_account,  length: { maximum: 32 }

  auto_strip_attributes :transfer_out_account, :transfer_in_account

  private

    def update_invoice!
      invoice.update_payment_related_columns!
    end

    def setup_denormalized_columns
      self.sales_order_id = invoice.sales_order_id if invoice_id_changed?
    end
end
