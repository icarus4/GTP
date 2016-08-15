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

require 'rails_helper'

RSpec.describe BinLocation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
