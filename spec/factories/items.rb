# == Schema Information
#
# Table name: items
#
#  id              :integer          not null, primary key
#  company_id      :integer
#  supplier_id     :integer
#  item_type_id    :integer
#  brand_id        :integer
#  unit            :string
#  status          :integer          default(0), not null
#  available_count :integer          default(0), not null
#  on_hand_count   :integer          default(0), not null
#  sku             :string
#  name            :string(255)      default(""), not null
#  description     :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  image           :string
#

FactoryGirl.define do
  factory :item do
    association :company, factory: :company
    supplier
    item_type
    brand
    unit { ['包', '箱', '個'].sample }
    available_count { 0 }
    on_hand_count { 0 }
    name { FFaker::Product.product }
  end
end
