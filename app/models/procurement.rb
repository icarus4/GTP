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

  validates :purchase_order_id, presence: true
end
