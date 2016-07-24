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

class BinLocation < ActiveRecord::Base
  belongs_to :location

  validates :location_id, presence: true
end
