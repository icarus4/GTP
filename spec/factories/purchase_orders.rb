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
