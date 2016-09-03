# == Schema Information
#
# Table name: payment_terms
#
#  id          :integer          not null, primary key
#  company_id  :integer          not null
#  name        :string           not null
#  due_in_days :integer          not null
#  start_from  :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_payment_terms_on_company_id  (company_id)
#

require 'rails_helper'

RSpec.describe PaymentTerm, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
