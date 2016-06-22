# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  name       :string(32)       not null
#  created_at :datetime
#

FactoryGirl.define do
  factory :city do
    name { FFaker::Address.city }
  end
end
