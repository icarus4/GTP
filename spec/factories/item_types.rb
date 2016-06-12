# == Schema Information
#
# Table name: item_types
#
#  id         :integer          not null, primary key
#  company_id :integer          not null
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :item_type do
    sequence(:name) { |n| "商品類別 - #{n}" }
  end
end
