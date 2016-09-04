# == Schema Information
#
# Table name: bin_locations
#
#  id          :integer          not null, primary key
#  location_id :integer          not null
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_bin_locations_on_location_id  (location_id)
#

class BinLocation < ActiveRecord::Base
  belongs_to :location

  validates :location_id, presence: true
  validates :name, uniqueness: { scope: :location_id }

  auto_strip_attributes :name
end
