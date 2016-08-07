# == Schema Information
#
# Table name: items
#
#  id                   :integer          not null, primary key
#  company_id           :integer          not null
#  item_series_id       :integer
#  available_count      :integer          default(0), not null
#  on_hand_count        :integer          default(0), not null
#  cost_per_unit        :integer
#  wholesale_price      :integer
#  retail_price         :integer
#  status               :integer          default(0), not null
#  weight_unit          :integer
#  weight_value         :decimal(10, 2)
#  manufactured_by_self :boolean          default(FALSE), not null
#  expirable            :boolean          default(TRUE), not null
#  sku                  :text
#  name                 :text             default(""), not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  image                :string
#

module ItemsHelper
end
