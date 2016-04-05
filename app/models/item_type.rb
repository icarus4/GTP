# == Schema Information
#
# Table name: item_types
#
#  id         :integer          not null, primary key
#  company_id :integer          not null
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ItemType < ActiveRecord::Base
  belongs_to :company
  has_many   :items, -> { where(company_id: company_id) }

  validates :company_id, presence: true
  validates :name,       presence: true, uniqueness: { scope: :company_id }
end