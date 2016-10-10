# == Schema Information
#
# Table name: item_packs
#
#  id         :integer          not null, primary key
#  item_id    :integer
#  name       :string           not null
#  size       :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_item_packs_on_item_id  (item_id)
#

require 'rails_helper'

RSpec.describe Item::Pack, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
