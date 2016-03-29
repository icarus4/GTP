# == Schema Information
#
# Table name: products
#
#  id              :integer          not null, primary key
#  company_id      :integer
#  supplier_id     :integer
#  product_type_id :integer
#  brand_id        :integer
#  status          :integer          default(0), not null
#  name            :string(255)      default(""), not null
#  description     :text
#  deleted_at      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Product < ActiveRecord::Base
  belongs_to :company
  belongs_to :supplier
  belongs_to :product_type, class_name: 'ProductType'
  belongs_to :brand
  has_many   :variants, dependent: :destroy

  accepts_nested_attributes_for :variants
  validates_associated :variants

  enum status: {
    active: 0,
    disabled: 1,
  }

  validates :name, presence: true
  validates :company_id,      presence: true
  validates :supplier_id,     presence: true
  validates :product_type_id, presence: true
  validates :brand_id,        presence: true
end
