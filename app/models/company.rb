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

class Company < ActiveRecord::Base

  enum status: {
    active: 0,
    disabled: 1
  }

  has_many :companies
  has_many :suppliers
  has_many :customers
  has_many :products

  validates :name, presence: true
end
