# == Schema Information
#
# Table name: partner_roles
#
#  id           :integer          not null, primary key
#  name         :string           not null
#  chinese_name :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class PartnerRole < ActiveRecord::Base
  has_many :partner_relationships
  has_many :partners, through: :partner_relationships

  validates :name, presence: true, uniqueness: true
  validates :chinese_name, presence: true, uniqueness: true
end
