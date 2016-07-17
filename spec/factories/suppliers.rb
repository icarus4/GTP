FactoryGirl.define do
  factory :supplier do
    company { Company.first || create(:company) }
    status 'active'
    name { "Supplier - #{FFaker::Company.name}" }
  end
end
