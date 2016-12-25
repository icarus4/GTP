# == Schema Information
#
# Table name: purchase_orders
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
#  line_items_count       :integer          default(0), not null
#  order_number           :string
#  status                 :integer          default(0), not null
#  email                  :string
#  return_status          :integer          default("unreturned"), not null
#  tax_treatment          :integer          default("exclusive"), not null
#  total_units            :integer
#  subtotal               :decimal(12, 2)
#  total_tax              :decimal(12, 2)
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
#  index_purchase_orders_on_company_id_and_partner_id  (company_id,partner_id)
#  index_purchase_orders_on_order_number               (order_number)
#

FactoryGirl.define do
  factory :purchase_order do
    company { Company.first || create(:company) }
    supplier
    association :bill_to, factory: :location
    association :ship_to, factory: :location
    status 'active'
    due_on { 1.week.from_now.to_date }

    before(:build) { |instance| instance.send(:setup_defaults) }
    before(:create) { |instance| instance.send(:setup_defaults) }
  end
end
