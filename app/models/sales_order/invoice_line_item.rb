# == Schema Information
#
# Table name: sales_order_invoice_line_items
#
#  id           :integer          not null, primary key
#  invoice_id   :integer          not null
#  line_item_id :integer          not null
#  quantity     :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_sales_order_invoice_line_items_on_invoice_id    (invoice_id)
#  index_sales_order_invoice_line_items_on_line_item_id  (line_item_id)
#

class SalesOrder::InvoiceLineItem < ApplicationRecord
  after_save    :update_line_item!
  after_destroy :update_line_item!

  belongs_to :invoice
  belongs_to :line_item

  validates :invoice_id, presence: true
  validates :line_item_id, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }

  private

    def update_line_item!
      line_item.update_invoice_related_columns!
    end
end
