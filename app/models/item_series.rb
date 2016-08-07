# == Schema Information
#
# Table name: item_series
#
#  id                              :integer          not null, primary key
#  company_id                      :integer          not null
#  brand_id                        :integer
#  manufacturer_id                 :integer
#  storage_and_transport_condition :integer
#  raw_material                    :text
#  food_additives                  :text
#  warnings                        :text
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#

class ItemSeries < ActiveRecord::Base
  belongs_to :company
  belongs_to :brand
  belongs_to :manufacturer

  validates :company_id, presence: true

  enum storage_and_transport_condition: {
    freezing:         1, # 冷凍 (<= -18 degree)
    refrigeration:    2, # 冷藏 (0~7 degree)
    eighteen_degrees: 3, # 18度C
    room_temperature: 4, # 常溫
    other:            5, # 其他
  }
end
