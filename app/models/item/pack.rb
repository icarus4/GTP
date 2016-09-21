# == Schema Information
#
# Table name: item_packs
#
#  id         :integer          not null, primary key
#  item_id    :integer
#  name       :string
#  size       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_item_packs_on_item_id  (item_id)
#

class Item::Pack < ApplicationRecord
  belongs_to :item

  validates :item_id, presence: true
  validates :name, presence: true
  validates :size, presence: true, numericality: { greater_than_or_equal_to: 2, only_integer: true }

  auto_strip_attributes :name
end
