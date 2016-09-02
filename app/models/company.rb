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

class Company < ActiveRecord::Base
  after_create :create_default_associations

  store_accessor :settings

  has_many :suppliers
  has_many :customers
  has_many :partners
  has_many :items
  has_many :variants, through: :items
  has_many :brands
  has_many :manufacturers, -> { joins(:roles).where(partner_roles: { name: 'manufacturer' }) }, class_name: 'Partner'
  has_many :item_series
  has_many :locations, as: :locationable
  has_many :purchase_orders
  has_many :stock_transfers
  has_many :sales_orders
  has_many :payment_methods
  has_many :payment_terms

  validates :name, presence: true

  enum status: {
    active: 0,
    disabled: 1
  }


  private

    def create_default_associations
      # PaymentMethod
      %w(現金 銀行轉帳 信用卡 支票).each { |name| PaymentMethod.create!(company: self, name: name) }

      # PaymentTerm
      [
        { name: '現結', start_from: 'invoice_date', due_in_days: 0 },
        { name: 'NET10', start_from: 'end_of_month', due_in_days: 10 },
        { name: 'NET30', start_from: 'end_of_month', due_in_days: 30 },
      ].each { |term| PaymentTerm.create!(company: self, name: term[:name], start_from: term[:start_from], due_in_days: term[:due_in_days]) }
    end
end
