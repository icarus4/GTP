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
#  settings    :jsonb            not null
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_companies_on_company_id  (company_id)
#  index_companies_on_type        (type)
#

class Company < ApplicationRecord
  after_create :create_default_associations!

  store_accessor :settings,
                 :default_payment_term_id,
                 :default_payment_method_id,
                 :default_tax_type_id

  has_many :partners
  has_many :manufacturers, -> { joins(:roles).where(partner_roles: { name: 'manufacturer' }) }, class_name: 'Partner'
  has_many :suppliers,     -> { joins(:roles).where(partner_roles: { name: 'supplier' }) }, class_name: 'Partner'
  has_many :customers,     -> { joins(:roles).where(partner_roles: { name: 'customer' }) }, class_name: 'Partner'
  has_many :items
  has_many :variants, through: :items
  has_many :brands
  has_many :item_series
  has_many :locations, as: :locationable
  has_many :purchase_orders
  has_many :purchase_order_returns
  has_many :stock_transfers
  has_many :sales_orders
  has_many :payment_methods
  has_many :payment_terms
  has_many :tax_types
  has_many :price_lists

  validates :name, presence: true

  auto_strip_attributes :name, :email, :vat_number, :phone, :fax, :website, :description

  enum status: {
    active: 0,
    disabled: 1
  }

  def default_payment_term
    return nil if default_payment_term_id.nil?
    @default_payment_term ||= PaymentTerm.find_by(company: self, id: default_payment_term_id)
  end

  def default_payment_method
    return nil if default_payment_method_id.nil?
    @default_payment_method ||= PaymentMethod.find_by(company: self, id: default_payment_method_id)
  end

  def default_tax_type
    return nil if default_tax_type_id.nil?
    @default_tax_type ||= TaxType.find_by(company: self, id: default_tax_type_id)
  end

  private

    def create_default_associations!
      create_default_payment_methods!
      create_default_payment_terms!
      create_default_tax_types!
    end

    DEFAULT_PAYMENT_METHODS = [
      { name: '現金', default: true },
      { name: '銀行轉帳', },
      { name: '信用卡', },
      { name: '支票', },
    ]
    def create_default_payment_methods!
      DEFAULT_PAYMENT_METHODS.each do |method|
        pm = PaymentMethod.create!(company: self, name: method[:name])
        update(default_payment_method_id: pm.id) if method[:default]
      end
    end

    DEFAULT_PAYMENT_TERMS = [
      { name: '現結', start_from: 'invoice_date', due_in_days: 0, default: true },
      { name: 'NET10', start_from: 'end_of_month', due_in_days: 10 },
      { name: 'NET30', start_from: 'end_of_month', due_in_days: 30 },
    ]
    def create_default_payment_terms!
      DEFAULT_PAYMENT_TERMS.each do |term|
        pt = PaymentTerm.create!(company: self, name: term[:name], start_from: term[:start_from], due_in_days: term[:due_in_days])
        update(default_payment_term_id: pt.id) if term[:default]
      end
    end

    DEFAULT_TAX_TYPES = [
      { name: '免稅', percentage: 0, default: true },
      { name: '營業稅', percentage: 5 },
    ]
    def create_default_tax_types!
      DEFAULT_TAX_TYPES.each do |term|
        tt = TaxType.create!(company: self, name: term[:name], percentage: term[:percentage])
        update(default_tax_type_id: tt.id) if term[:default]
      end
    end
end
