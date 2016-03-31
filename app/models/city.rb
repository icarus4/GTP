# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  name       :string(32)       not null
#  created_at :datetime
#

class City < ActiveRecord::Base
  has_many :locations
end
