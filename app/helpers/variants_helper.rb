# == Schema Information
#
# Table name: variants
#
#  id              :integer          not null, primary key
#  product_id      :integer          not null
#  sku             :string
#  name            :string
#  buy_price       :integer
#  cost_per_unit   :integer
#  retail_price    :integer
#  wholesale_price :integer
#  available_count :integer          default(0), not null
#  on_hand_count   :integer          default(0), not null
#  weight_value    :decimal(8, 2)
#  weight_unit_id  :integer
#  description     :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

module VariantsHelper
end
