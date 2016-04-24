# == Schema Information
#
# Table name: location_variants
#
#  id          :integer          not null, primary key
#  company_id  :integer
#  location_id :integer
#  variant_id  :integer
#  quantity    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class LocationVariant < ActiveRecord::Base
  belongs_to :company
  belongs_to :location
  belongs_to :variant
end
