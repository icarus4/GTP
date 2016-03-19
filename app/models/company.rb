# == Schema Information
#
# Table name: companies
#
#  id                :integer          not null, primary key
#  company_id        :integer
#  assignee_id       :integer
#  relationship_type :integer          default(0), not null
#  status            :integer          default(0), not null
#  name              :string
#  email             :string
#  vat_number        :string
#  phone             :string
#  fax               :string
#  website           :string
#  description       :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Company < ActiveRecord::Base

  enum relationship_type: {
    self: 0,
    supplier: 1,
    business_customer: 2,
    consumer: 3
  }

  enum status: {
    active: 0,
    disabled: 1
  }

  validates :name, presence: true

  has_many :companies, class_name: 'Company'
end
