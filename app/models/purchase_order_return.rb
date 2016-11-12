# == Schema Information
#
# Table name: purchase_order_returns
#
#  id                :integer          not null, primary key
#  company_id        :integer
#  purchase_order_id :integer
#  order_number      :string
#  notes             :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_purchase_order_returns_on_company_id         (company_id)
#  index_purchase_order_returns_on_order_number       (order_number)
#  index_purchase_order_returns_on_purchase_order_id  (purchase_order_id)
#

class PurchaseOrderReturn < ApplicationRecord
  before_create :setup_defaults

  belongs_to :company
  belongs_to :purchase_order

  has_many :line_items, class_name: 'PurchaseOrderReturnLineItem', dependent: :destroy

  validates :purchase_order_id, presence: true
  validates :order_number, uniqueness: { scope: :company_id }

  auto_strip_attributes :notes, :order_number

  private

    def setup_defaults
      self.company_id = purchase_order.company_id
      self.order_number ||= (self.class.where(company_id: company_id).maximum(:order_number).try(:next) || 'PR0001') if company_id
    end
end
