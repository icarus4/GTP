# == Schema Information
#
# Table name: orders
#
#  id                      :integer          not null, primary key
#  company_id              :integer          not null
#  partner_id              :integer
#  currency_id             :integer
#  payment_method_id       :integer
#  type                    :string
#  assignee_id             :integer
#  bill_to_location_id     :integer
#  ship_from_location_id   :integer
#  ship_to_location_id     :integer
#  order_number            :string
#  state                   :string
#  status                  :string
#  total_are_tax_inclusive :boolean
#  total_units             :integer
#  total_amount            :decimal(12, 2)
#  paid_on                 :date
#  expected_delivery_date  :date
#  extra_info              :jsonb
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
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

class Order < ApplicationRecord
  belongs_to :company
  belongs_to :partner
  belongs_to :bill_to_location, class_name: 'Location', foreign_key: :bill_to_location_id
  belongs_to :ship_to_location, class_name: 'Location', foreign_key: :ship_to_location_id
  belongs_to :currency
  belongs_to :payment_method
  belongs_to :assignee, class_name: 'User'
end
