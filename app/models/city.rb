# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  name       :string(32)       not null
#  created_at :datetime
#
# Indexes
#
#  index_cities_on_name  (name)
#

class City < ActiveRecord::Base
  has_many :locations

  validates :name, presence: true, uniqueness: true
  
  auto_strip_attributes :name
end
