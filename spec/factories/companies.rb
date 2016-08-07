# == Schema Information
#
# Table name: companies
#
#  id          :integer          not null, primary key
#  company_id  :integer
#  assignee_id :integer
#  status      :integer          default(0), not null
#  type        :string           default(""), not null
#  name        :string
#  email       :string
#  vat_number  :string
#  phone       :string
#  fax         :string
#  website     :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_companies_on_company_id  (company_id)
#  index_companies_on_type        (type)
#

FactoryGirl.define do
  factory :company do
    status 'active'
    name { "Company - #{FFaker::Company.name}" }
  end
end
