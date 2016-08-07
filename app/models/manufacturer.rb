# == Schema Information
#
# Table name: manufacturers
#
#  id                  :integer          not null, primary key
#  company_id          :integer
#  foreign             :boolean          default(FALSE), not null
#  name                :string
#  registration_number :string
#  address             :string
#
# Indexes
#
#  index_manufacturers_on_company_id  (company_id)
#

class Manufacturer < ActiveRecord::Base
  belongs_to :company

  validates :name, :company_id, presence: true
end
