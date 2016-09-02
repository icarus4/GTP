# == Schema Information
#
# Table name: companies
#
#  id          :integer          not null, primary key
#  company_id  :integer
#  assignee_id :integer
#  status      :integer          default("active"), not null
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

class Customer < Company
  belongs_to :company
  has_many :locations, as: :locationable

  validates :name, :company_id, presence: true
end
