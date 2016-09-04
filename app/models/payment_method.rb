# == Schema Information
#
# Table name: payment_methods
#
#  id         :integer          not null, primary key
#  company_id :integer          not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_payment_methods_on_company_id  (company_id)
#

class PaymentMethod < ApplicationRecord
  belongs_to :company

  validates :company_id, presence: true
  validates :name, presence: true, uniqueness: { scope: :company_id }
  
  auto_strip_attributes :name

  def default?(_company = nil)
    _company = _company || company
    id == _company.default_payment_method_id
  end
end
