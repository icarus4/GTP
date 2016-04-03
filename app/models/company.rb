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
  has_many :brands
  has_many :product_types, -> { where(company_id: id) }, class_name: 'ProductType'
  has_many :locations, as: :locationable
  has_many :purchase_orders  

  validates :name, presence: true
end
