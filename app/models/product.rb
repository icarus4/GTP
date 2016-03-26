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
  belongs_to :product_type
  belongs_to :brand

  enum status: {
    active: 0,
    disabled: 1,
  }

  validates :name, presence: true
end
