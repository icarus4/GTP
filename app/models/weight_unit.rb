# == Schema Information
#
# Table name: weight_units
#
#  id         :integer          not null, primary key
#  company_id :integer          not null
#  name       :string(32)       not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class WeightUnit < ActiveRecord::Base
  belongs_to :company
end
