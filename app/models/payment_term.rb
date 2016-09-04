# == Schema Information
#
# Table name: payment_terms
#
#  id          :integer          not null, primary key
#  company_id  :integer          not null
#  name        :string           not null
#  due_in_days :integer          not null
#  start_from  :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_payment_terms_on_company_id  (company_id)
#

class PaymentTerm < ApplicationRecord
  belongs_to :company

  validates :company_id, presence: true
  validates :name, presence: true, uniqueness: { scope: :company_id }
  validates :due_in_days, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :start_from, presence: true

  auto_strip_attributes :name

  enum start_from: {
    invoice_date: 0,
    end_of_month: 1,
  }

  START_FROM_MAPPING = {
    'invoice_date' => '請款日後',
    'end_of_month' => '當月底後',
  }

  def start_from_in_chinese
    START_FROM_MAPPING.fetch(start_from)
  end

  def full_name_in_chinese
    "#{start_from_in_chinese} #{due_in_days} 天內"
  end

  def default?(_company = nil)
    _company = _company || company
    id == _company.default_payment_term_id
  end
end
