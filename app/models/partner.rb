# == Schema Information
#
# Table name: partners
#
#  id                                          :integer          not null, primary key
#  company_id                                  :integer          not null
#  partner_type                                :integer          not null
#  status                                      :integer          not null
#  receipt_type                                :integer          not null
#  name                                        :string(128)      not null
#  alias_name                                  :string(128)
#  email                                       :string(64)
#  tax_number                                  :string(32)
#  phone                                       :string(32)
#  fax                                         :string(32)
#  food_industry_registration_number           :string(64)
#  factory_registration_number                 :string(64)
#  no_food_industry_registration_number_reason :string(255)
#  website                                     :string(255)
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

  store_accessor :settings,
                 :default_payment_method_id

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

  enum receipt_type: {
    receipt_free: 0,
    two_parts: 1,
    three_parts: 2,
  }

  RECEIPT_TYPE_MAPPING = {
    "receipt_free" => "不開發票",
    "two_parts" => "二聯式",
    "three_parts" => "三聯式",
  }

  PARTNER_TYPE_MAPPING = {
    "domestic_company" => "國內公司",
    "foreign_company" => "國外公司",
    "person" => "散客",
  }

  validates :partner_type, presence: true

  def name_and_alias_name
    alias_name.present? ? "#{alias_name} (#{name})" : name
  end

  def receipt_type_in_chinese
    RECEIPT_TYPE_MAPPING.fetch(receipt_type)
  end

  def partner_type_in_chinese
    PARTNER_TYPE_MAPPING.fetch(partner_type)
  end

  def default_payment_method
    return nil if default_payment_method_id.nil?
    @default_payment_method ||= PaymentMethod.find_by(company_id: company_id, id: default_payment_method_id)
  end

  private

    def setup_defaults
      self.partner_type ||= self.class.partner_types['domestic_company']
      self.receipt_type ||= self.class.receipt_types['receipt_free']
      self.status ||= self.class.statuses['active']
    end
end
