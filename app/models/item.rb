# == Schema Information
#
# Table name: items
#
#  id           :integer          not null, primary key
#  company_id   :integer
#  supplier_id  :integer
#  item_type_id :integer
#  brand_id     :integer
#  status       :integer          default(0), not null
#  name         :string(255)      default(""), not null
#  description  :text
#  deleted_at   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Item < ActiveRecord::Base
  belongs_to :company
  belongs_to :supplier
  belongs_to :item_type, class_name: 'ItemType'
  belongs_to :brand
  has_many   :variants, dependent: :destroy

  accepts_nested_attributes_for :variants
  validates_associated :variants

  enum status: {
    active: 0,
    disabled: 1,
  }

  validates :name,         presence: true
  validates :company_id,   presence: true
  validates :supplier_id,  presence: true
  validates :item_type_id, presence: true
  validates :brand_id,     presence: true
end
