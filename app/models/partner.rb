# == Schema Information
#
# Table name: partners
#
#  id                                          :integer          not null, primary key
#  company_id                                  :integer          not null
#  partner_type                                :integer          default(0), not null
#  location_type                               :integer          default(0), not null
#  status                                      :integer          default(0), not null
#  name                                        :string(128)      not null
#  alias_name                                  :string(128)
#  email                                       :string(64)
#  tax_number                                  :string(32)
#  phone                                       :string(32)
#  fax                                         :string(32)
#  food_industry_registration_number           :string(64)
#  factory_registration_number                 :string(64)
#  website                                     :string(255)
#  no_food_industry_registration_number_reason :string(255)
#  description                                 :text
#  created_at                                  :datetime         not null
#  updated_at                                  :datetime         not null
#
# Indexes
#
#  index_partners_on_alias_name  (alias_name)
#  index_partners_on_company_id  (company_id)
#  index_partners_on_name        (name)
#

class Partner < ActiveRecord::Base
  after_initialize :setup_defaults

  belongs_to :company
  has_many :partner_relationships
  has_many :roles, through: :partner_relationships, class_name: 'PartnerRole', foreign_key: 'partner_role_id'
  has_many :locations, as: :locationable

  validates :company_id, presence: true
  validates :name, presence: true
  validates :tax_number, uniqueness: { scope: :company_id }, allow_blank: true

  enum status: {
    active: 0
  }

  enum partner_type: {
    domestic_company: 0,
    foreign_company: 1,
    person: 2,
  }

  def name_and_alias_name
    alias_name.present? ? "#{alias_name} (#{name})" : name
  end

  private

    def setup_defaults
      self.partner_type = 'domestic_company'
      self.status = 'active'
    end
end
