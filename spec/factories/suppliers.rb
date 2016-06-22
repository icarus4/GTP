FactoryGirl.define do
  factory :supplier do
    company
    status 'active'
    name { "Supplier - #{FFaker::Company.name}" }
  end
end
