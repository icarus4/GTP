# == Schema Information
#
# Table name: items
#
#  id              :integer          not null, primary key
#  company_id      :integer
#  supplier_id     :integer
#  item_type_id    :integer
#  brand_id        :integer
#  unit            :string
#  status          :integer          default(0), not null
#  available_count :integer          default(0), not null
#  on_hand_count   :integer          default(0), not null
#  sku             :string
#  name            :string(255)      default(""), not null
#  description     :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

module ItemsHelper
end
