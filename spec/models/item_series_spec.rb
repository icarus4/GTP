# == Schema Information
#
# Table name: item_series
#
#  id                                   :integer          not null, primary key
#  company_id                           :integer          not null
#  brand_id                             :integer
#  manufacturer_id                      :integer
#  storage_and_transport_condition      :integer
#  storage_and_transport_condition_note :text
#  raw_material                         :text
#  food_additives                       :text
#  warnings                             :text
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#

require 'rails_helper'

RSpec.describe ItemSeries, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
