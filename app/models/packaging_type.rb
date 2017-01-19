# == Schema Information
#
# Table name: packaging_types
#
#  id         :integer          not null, primary key
#  company_id :integer
#  name       :string
#  code       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_packaging_types_on_company_id  (company_id)
#

class PackagingType < ApplicationRecord
  belongs_to :company

  validates :name, presence: true, uniqueness: { scope: :company_id }

  auto_strip_attributes :name, :code

  CODE_NAME_MAPPING = {
    '01' => '袋',
    '02' => '瓶',
    '03' => '桶',
    '04' => '罐',
    '05' => '盒',
    '06' => '包',
    '07' => '個',
    '08' => '份',
    '09' => '箱',
    '99' => '其他',
  }
end
