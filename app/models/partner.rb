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
#  settings                                    :jsonb            not null
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
                 :default_sales_payment_term_id,      # 預設收款條件
                 :default_sales_payment_method_id,    # 預設收款方式
                 :default_purchase_payment_term_id,   # 預設付款條件
                 :default_purchase_payment_method_id, # 預設付款方式
                 :default_tax_type_id,                # 預設稅別
                 :default_receiving_location_id       # 預設收貨倉庫

  # Convert all store_accessor values to integer
  stored_attributes[:settings].each do |accessor_name|
    self.class_eval do
      define_method(accessor_name) do
        super().to_i
      end
      define_method(:"#{accessor_name}=") do |value|
        super(value.to_i)
      end
    end
  end

  belongs_to :company
  has_many :partner_relationships
  has_many :roles, through: :partner_relationships, class_name: 'PartnerRole', foreign_key: 'partner_role_id'
  has_many :locations, as: :locationable
  has_many :contacts, as: :contactable

  validates :company_id, presence: true
  validates :name, presence: true
  validates :tax_number, uniqueness: { scope: :company_id }, allow_blank: true

  auto_strip_attributes :name,
                        :alias_name,
                        :email,
                        :tax_number,
                        :phone,
                        :fax,
                        :food_industry_registration_number,
                        :factory_registration_number,
                        :no_food_industry_registration_number_reason,
                        :website,
                        :description

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

  # 預設收款方式
  def default_sales_payment_method
    return nil if default_sales_payment_method_id.nil?
    @default_sales_payment_method ||= PaymentMethod.find_by(company_id: company_id, id: default_sales_payment_method_id)
  end

  # 預設付款方式
  def default_purchase_payment_method
    return nil if default_purchase_payment_method_id.nil?
    @default_purchase_payment_method ||= PaymentMethod.find_by(company_id: company_id, id: default_purchase_payment_method_id)
  end

  # 預設收款條件
  def default_sales_payment_term
    return nil if default_sales_payment_term_id.nil?
    @default_sales_payment_term ||= PaymentTerm.find_by(company_id: company_id, id: default_sales_payment_term_id)
  end

  # 預設付款條件
  def default_purchase_payment_term
    return nil if default_purchase_payment_term_id.nil?
    @default_purchase_payment_term ||= PaymentTerm.find_by(company_id: company_id, id: default_purchase_payment_term_id)
  end

  # 預設稅別
  def default_tax_type
    return nil if default_tax_type_id.nil?
    @default_tax_type ||= TaxType.find_by(company_id: company_id, id: default_tax_type_id)
  end

  def default_receiving_location
    return nil if default_receiving_location_id.nil?
    @default_receiving_location ||= Location.holds_stock.find_by(locationable: company, id: default_receiving_location_id)
  end

  private

    def setup_defaults
      self.partner_type ||= self.class.partner_types['domestic_company'] if has_attribute?(:partner_type)
      self.receipt_type ||= self.class.receipt_types['receipt_free'] if has_attribute?(:receipt_type)
      self.status ||= self.class.statuses['active'] if has_attribute?(:status)
    end
end
