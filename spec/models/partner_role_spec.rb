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

require 'rails_helper'

RSpec.describe PartnerRole, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
