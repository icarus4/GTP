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

class PartnerRole < ApplicationRecord
  has_many :partner_relationships
  has_many :partners, through: :partner_relationships

  validates :name, presence: true, uniqueness: true
  validates :chinese_name, presence: true, uniqueness: true

  auto_strip_attributes :name, :chinese_name
end
