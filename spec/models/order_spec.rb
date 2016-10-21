# == Schema Information
#
# Table name: orders
#
#  id                     :integer          not null, primary key
#  company_id             :integer          not null
#  partner_id             :integer
#  currency_id            :integer
#  payment_method_id      :integer
#  assignee_id            :integer
#  bill_to_location_id    :integer
#  ship_from_location_id  :integer
#  ship_to_location_id    :integer
#  type                   :string
#  order_number           :string
#  state                  :string
#  status                 :string
#  email                  :string
#  tax_treatment          :integer          default(0), not null
#  total_units            :integer
#  total_amount           :decimal(12, 2)
#  paid_on                :date
#  expected_delivery_date :date
#  notes                  :text
#  extra_info             :jsonb
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_orders_on_assignee_id   (assignee_id)
#  index_orders_on_company_id    (company_id)
#  index_orders_on_order_number  (order_number)
#  index_orders_on_partner_id    (partner_id)
#  index_orders_on_state         (state)
#  index_orders_on_status        (status)
#  index_orders_on_type          (type)
#

require 'rails_helper'

RSpec.describe Order, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
