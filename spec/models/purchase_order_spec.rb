# == Schema Information
#
# Table name: purchase_orders
#
#  id                  :integer          not null, primary key
#  company_id          :integer
#  supplier_id         :integer
#  bill_to_location_id :integer
#  ship_to_location_id :integer
#  status              :string
#  total_amount        :integer
#  due_on              :date
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  order_number        :string(64)
#  contact_email       :string(64)
#  notes               :text
#

require 'rails_helper'

RSpec.describe PurchaseOrder do
  describe '#receive!' do
    it 'updates available_count of items belongs to it' do
      order = create(:purchase_order)
      ap order
    end

    it 'second' do
      ap Company.all
    end
  end
end
