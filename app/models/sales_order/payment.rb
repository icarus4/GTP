# == Schema Information
#
# Table name: sales_order_payments
#
#  id                   :integer          not null, primary key
#  invoice_id           :integer          not null
#  payment_method_id    :integer
#  amount               :decimal(12, 2)
#  transfer_out_account :string
#  transfer_in_account  :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_sales_order_payments_on_invoice_id         (invoice_id)
#  index_sales_order_payments_on_payment_method_id  (payment_method_id)
#

class SalesOrder::Payment < ApplicationRecord
  belongs_to :invoice
  belongs_to :payment_method

  validates :invoice_id, presence: true
end
