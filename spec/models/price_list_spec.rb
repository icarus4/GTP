# == Schema Information
#
# Table name: price_lists
#
#  id              :integer          not null, primary key
#  company_id      :integer          not null
#  name            :string           not null
#  price_list_type :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_price_lists_on_company_id  (company_id)
#

require 'rails_helper'

RSpec.describe PriceList, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
