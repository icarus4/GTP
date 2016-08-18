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

  after_initialize :setup_defaults

  validates :name, :company_id, :location_type, presence: true
  validates :registration_number, uniqueness: { scope: :company_id }, allow_nil: true

  enum location_type: {
    domestic: 0,
    foreign:  1,
  }

  private

    def setup_defaults
      self.location_type = 'domestic'
    end
end
