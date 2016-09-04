# == Schema Information
#
# Table name: item_series
#
#  id                                   :integer          not null, primary key
#  company_id                           :integer          not null
#  brand_id                             :integer
#  manufacturer_id                      :integer
#  storage_and_transport_condition      :integer
#  expiration_alert_days                :integer
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

class ItemSeries < ActiveRecord::Base
  belongs_to :company
  belongs_to :brand
  belongs_to :manufacturer, class_name: 'Partner'
  has_many :items

  validates :company_id, presence: true
  validates :brand_id, presence: true
  validates :manufacturer_id, presence: true
  validates :name, presence: true, uniqueness: { scope: :company_id }
  validates :expiration_alert_days, numericality: { greater_than_or_equal_to: 0, only_integer: true}, allow_nil: true

  auto_strip_attributes :name, :raw_material, :main_and_auxiliary_material, :food_additives, :warnings

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

  def sku
    "IS%04d" % id
  end
end
