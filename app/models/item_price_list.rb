# == Schema Information
#
# Table name: item_price_lists
#
#  id            :integer          not null, primary key
#  item_id       :integer          not null
#  price_list_id :integer          not null
#  price         :decimal(12, 2)   not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_item_price_lists_on_item_id                    (item_id)
#  index_item_price_lists_on_item_id_and_price_list_id  (item_id,price_list_id) UNIQUE
#  index_item_price_lists_on_price_list_id              (price_list_id)
#

class ItemPriceList < ApplicationRecord
  delegate :name, :price_list_type_in_chinese, to: :price_list
  belongs_to :item
  belongs_to :price_list

  validates :item_id, presence: true
  validates :price_list_id, presence: true, uniqueness: { scope: :item_id }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
