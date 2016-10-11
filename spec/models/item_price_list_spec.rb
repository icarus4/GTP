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

require 'rails_helper'

RSpec.describe ItemPriceList, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
