# == Schema Information
#
# Table name: purchase_order_details
#
#  id                :integer          not null, primary key
#  purchase_order_id :integer
#  variant_id        :integer
#  quantity          :integer
#  cost_per_unit     :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class PurchaseOrderDetail < ActiveRecord::Base
  belongs_to :variant
  belongs_to :purchase_order

  validates :purchase_order_id, :variant_id, :quantity, :cost_per_unit, presence: true
end
