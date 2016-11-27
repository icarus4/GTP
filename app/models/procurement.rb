# == Schema Information
#
# Table name: procurements
#
#  id                :integer          not null, primary key
#  purchase_order_id :integer          not null
#  procured_at       :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_procurements_on_purchase_order_id  (purchase_order_id)
#

class Procurement < ApplicationRecord
  belongs_to :purchase_order
  has_many :purchase_order_line_items, class_name: 'Order::LineItem', foreign_key: :procurement_id
  has_many :returnable_purchase_order_line_items, -> { returnable }, class_name: 'Order::LineItem', foreign_key: :procurement_id
  has_many :variants

  validates :purchase_order_id, presence: true
end
