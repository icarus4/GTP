# == Schema Information
#
# Table name: locations
#
#  id                :integer          not null, primary key
#  locationable_id   :integer
#  locationable_type :string
#  city_id           :integer
#  zip               :string(8)
#  address           :string(255)
#  name              :string(255)
#  holds_stock       :boolean          default(TRUE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

module LocationsHelper
end
