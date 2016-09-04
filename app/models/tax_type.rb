# == Schema Information
#
# Table name: tax_types
#
#  id         :integer          not null, primary key
#  company_id :integer          not null
#  percentage :decimal(4, 1)    not null
#  rate       :decimal(4, 3)    not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_tax_types_on_company_id  (company_id)
#

class TaxType < ApplicationRecord
  belongs_to :company

  before_validation :calculate_rate

  validates :company_id, presence: true
  validates :name, presence: true, uniqueness: { scope: :company_id }
  validates :rate,       numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 9.999 }
  validates :percentage, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 999.9 }

  auto_strip_attributes :name

  def default?(_company = nil)
    _company = _company || company
    id == _company.default_tax_type_id
  end

  private

    def calculate_rate
      self.rate = percentage.to_d / 100
    end
end
