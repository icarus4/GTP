# == Schema Information
#
# Table name: brands
#
#  id         :integer          not null, primary key
#  company_id :integer          not null
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Brand < ActiveRecord::Base
  belongs_to :company

  validates :company_id, presence: true
  valudates :name,       presence: true, uniqueness: { scope: :company_id }
end
