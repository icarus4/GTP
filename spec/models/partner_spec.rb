# == Schema Information
#
# Table name: partners
#
#  id                                          :integer          not null, primary key
#  company_id                                  :integer          not null
#  partner_type                                :integer          default(0), not null
#  location_type                               :integer          default(0), not null
#  status                                      :integer          default(0), not null
#  name                                        :string(128)      not null
#  alias_name                                  :string(128)
#  email                                       :string(64)
#  tax_number                                  :string(32)
#  phone                                       :string(32)
#  fax                                         :string(32)
#  food_industry_registration_number           :string(64)
#  factory_registration_number                 :string(64)
#  website                                     :string(255)
#  no_food_industry_registration_number_reason :string(255)
#  description                                 :text
#  created_at                                  :datetime         not null
#  updated_at                                  :datetime         not null
#
# Indexes
#
#  index_partners_on_alias_name  (alias_name)
#  index_partners_on_company_id  (company_id)
#  index_partners_on_name        (name)
#

require 'rails_helper'

RSpec.describe Partner, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
