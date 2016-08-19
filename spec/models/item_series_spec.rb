# == Schema Information
#
# Table name: item_series
#
#  id                                   :integer          not null, primary key
#  company_id                           :integer          not null
#  brand_id                             :integer
#  manufacturer_id                      :integer
#  storage_and_transport_condition      :integer
#  name                                 :string
#  storage_and_transport_condition_note :string
#  raw_material                         :text
#  main_and_auxiliary_material          :text
#  food_additives                       :text
#  warnings                             :text
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#
# Indexes
#
#  index_item_series_on_company_id  (company_id)
#  index_item_series_on_name        (name)
#

require 'rails_helper'

RSpec.describe ItemSeries, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
