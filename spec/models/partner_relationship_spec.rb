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

require 'rails_helper'

RSpec.describe PartnerRelationship, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
