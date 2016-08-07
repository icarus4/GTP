# == Schema Information
#
# Table name: manufacturers
#
#  id                  :integer          not null, primary key
#  company_id          :integer
#  location_type       :integer
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

  validates :name, :company_id, :location_type, presence: true
  validates :registration_number, uniqueness: { scope: :company_id }

  enum location_type: {
    domestic: 0,
    foreign:  1,
  }
end
