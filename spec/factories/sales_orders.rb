# == Schema Information
#
# Table name: sales_orders
#
#  id                    :integer          not null, primary key
#  company_id            :integer
#  customer_id           :integer
#  bill_to_location_id   :integer
#  ship_to_location_id   :integer
#  ship_from_location_id :integer
#  assignee_id           :integer
#  status                :string
#  total_amount          :integer
#  issued_on             :date
#  shipped_on            :date
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  order_number          :string(64)
#  contact_email         :string(64)
#  notes                 :text
#
# Indexes
#
#  index_sales_orders_on_company_id_and_customer_id  (company_id,customer_id)
#  index_sales_orders_on_status                      (status)
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
