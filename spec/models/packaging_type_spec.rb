# == Schema Information
#
# Table name: packaging_types
#
#  id         :integer          not null, primary key
#  company_id :integer
#  name       :string
#  code       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_packaging_types_on_company_id  (company_id)
#

require 'rails_helper'

RSpec.describe PackagingType, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
