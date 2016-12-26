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

require 'rails_helper'

RSpec.describe PurchaseOrderReturn, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
