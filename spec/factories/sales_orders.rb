# == Schema Information
#
# Table name: sales_orders
#
#  id                      :integer          not null, primary key
#  company_id              :integer
#  partner_id              :integer
#  bill_to_location_id     :integer
#  ship_to_location_id     :integer
#  ship_from_location_id   :integer
#  assignee_id             :integer
#  payment_method_id       :integer
#  status                  :integer          default("draft"), not null
#  invoice_status          :integer          default("uninvoiced"), not null
#  packing_status          :integer          default(0), not null
#  shipment_status         :integer          default("unshipped"), not null
#  payment_status          :integer          default("unpaid"), not null
#  tax_treatment           :integer          default("exclusive"), not null
#  line_items_count        :integer          default(0), not null
#  total_units             :integer          default(0), not null
#  subtotal                :decimal(12, 2)
#  total_tax               :decimal(12, 2)
#  total_amount            :decimal(12, 2)
#  issued_on               :date
#  expected_delivery_date  :date
#  order_number            :string
#  email                   :string
#  phone                   :string
#  notes                   :text
#  extra_info              :jsonb
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  invoiced_quantity       :integer
#  uninvoiced_quantity     :integer
#  invoiced_total_amount   :decimal(12, 2)
#  uninvoiced_total_amount :decimal(12, 2)
#  paid_total_amount       :decimal(12, 2)
#  unpaid_total_amount     :decimal(12, 2)
#
# Indexes
#
#  index_sales_orders_on_company_id_and_partner_id  (company_id,partner_id)
#  index_sales_orders_on_order_number               (order_number)
#

FactoryGirl.define do
  factory :sales_order do
    company { Company.first || create(:company) }
    customer
    association :bill_to, factory: :location
    association :ship_to, factory: :location
    association :ship_from, factory: :location
    status 'active'
    issued_on { Time.zone.today }
    shipped_on { rand(3..30).days.from_now.to_date }

    before(:build) { |instance| instance.send(:setup_defaults) }
    before(:create) { |instance| instance.send(:setup_defaults) }

    factory :sales_order_with_details do
      transient do
        details_count 3
      end

      after(:create) do |sales_order, evaluator|
        create_list(:sales_order_detail, evaluator.details_count, sales_order: sales_order)
      end
    end
  end
end
