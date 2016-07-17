# == Schema Information
#
# Table name: brands
#
#  id         :integer          not null, primary key
#  company_id :integer          not null
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :brand do
    company { Company.first || create(:company) }
    name { FFaker::Product.brand }
  end
end
