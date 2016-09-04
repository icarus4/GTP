# == Schema Information
#
# Table name: tax_types
#
#  id         :integer          not null, primary key
#  company_id :integer          not null
#  percentage :decimal(4, 1)    not null
#  rate       :decimal(4, 3)    not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_tax_types_on_company_id  (company_id)
#

require 'rails_helper'

RSpec.describe TaxType, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
