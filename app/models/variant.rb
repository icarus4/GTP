# == Schema Information
#
# Table name: variants
#
#  id              :integer          not null, primary key
#  product_id      :integer          not null
#  sku             :string
#  name            :string
#  buy_price       :decimal(8, 2)
#  retail_price    :decimal(8, 2)
#  wholesale_price :decimal(8, 2)
#  available_count :integer          default(0), not null
#  on_hand_count   :integer          default(0), not null
#  weight_value    :decimal(, )
#  weight_unit_id  :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Variant < ActiveRecord::Base
end
