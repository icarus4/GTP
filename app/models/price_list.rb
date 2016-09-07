# == Schema Information
#
# Table name: price_lists
#
#  id              :integer          not null, primary key
#  company_id      :integer          not null
#  name            :string           not null
#  price_list_type :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_price_lists_on_company_id  (company_id)
#

class PriceList < ApplicationRecord
  belongs_to :company
  has_many :item_price_lists
  has_many :items, through: :item_price_lists

  validates :company_id, presence: true
  validates :name, presence: true, uniqueness: { scope: :company_id }

  enum price_list_type: {
    purchase: 0,
    sales: 1
  }

  PRICE_LIST_TYPE_CHINESE_MAPPING = {
    'purchase' => '進貨',
    'sales'    => '銷售',
  }
  def price_list_type_in_chinese
    PRICE_LIST_TYPE_CHINESE_MAPPING.fetch(price_list_type)
  end
end
