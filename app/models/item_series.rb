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

class ItemSeries < ActiveRecord::Base
  belongs_to :company
  belongs_to :brand
  belongs_to :manufacturer
  has_many :items

  validates :company_id, presence: true

  enum storage_and_transport_condition: {
    freezing:         1, # 冷凍 (<= -18 degree)
    refrigeration:    2, # 冷藏 (0~7 degree)
    eighteen_degrees: 3, # 18度C
    room_temperature: 4, # 常溫
    other:            5, # 其他
  }

  def storage_and_transport_condition_in_chinese
    mapping = {
      'freezing'         => '冷凍',
      'refrigeration'    => '冷藏',
      'eighteen_degrees' => '18度C',
      'room_temperature' => '常溫',
      'other'            => '其他',
    }
    mapping[storage_and_transport_condition]
  end
end
