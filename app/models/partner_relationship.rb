# == Schema Information
#
# Table name: partner_relationships
#
#  id              :integer          not null, primary key
#  partner_id      :integer          not null
#  partner_role_id :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_partner_relationships_on_partner_id_and_partner_role_id  (partner_id,partner_role_id) UNIQUE
#

class PartnerRelationship < ActiveRecord::Base
  belongs_to :partner
  belongs_to :role, class_name: 'PartnerRole', foreign_key: 'partner_role_id'

  validates :partner_id, presence: true
  validates :partner_role_id, presence: true
end
