# == Schema Information
#
# Table name: locations
#
#  id                :integer          not null, primary key
#  locationable_id   :integer
#  locationable_type :string
#  city_id           :integer
#  zip               :string(8)
#  phone             :string(32)
#  email             :string(64)
#  address           :string(255)
#  name              :string(255)
#  holds_stock       :boolean          default(FALSE), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_locations_on_locationable_type_and_locationable_id  (locationable_type,locationable_id)
#

FactoryGirl.define do
  factory :location do
    city
    address { FFaker::Address.street_address }
    name { FFaker::Address.neighborhood }
  end
end
