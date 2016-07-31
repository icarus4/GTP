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
# Indexes
#
#  index_brands_on_company_id_and_name  (company_id,name) UNIQUE
#

FactoryGirl.define do
  factory :brand do
    company { Company.first || create(:company) }
    name { FFaker::Product.brand }
  end
end
