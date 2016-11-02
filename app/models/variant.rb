# == Schema Information
#
# Table name: variants
#
#  id                            :integer          not null, primary key
#  item_id                       :integer          not null
#  procurement_id                :integer
#  quantity                      :integer          default(0), not null
#  manufacturing_date            :date
#  expiry_date                   :date
#  import_admitted_notice_number :string(255)
#  goods_declaration_number      :string(255)
#  item_number                   :string(255)
#  lot_number                    :string(255)
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
# Indexes
#
#  index_variants_on_expiry_date                    (expiry_date)
#  index_variants_on_goods_declaration_number       (goods_declaration_number)
#  index_variants_on_import_admitted_notice_number  (import_admitted_notice_number)
#  index_variants_on_item_id                        (item_id)
#  index_variants_on_procurement_id                 (procurement_id)
#

class Variant < ActiveRecord::Base
  after_save :update_item_on_hand_count!

  belongs_to :item
  belongs_to :procurement
  has_many :purchase_order_details
  has_many :purchase_orders, through: :purchase_order_details
  has_many :sales_order_details
  has_many :sales_orders, through: :sales_order_details
  has_many :location_variants
  has_many :bin_locations, through: :location_variants

  delegate :company, to: :item
  delegate :sku_name, to: :item

  validates :item_id, presence: true
  validates :expiry_date, uniqueness: {
    scope: [
      :procurement_id,
      :item_id,
      :import_admitted_notice_number,
      :goods_declaration_number,
      :item_number,
      :lot_number
    ]
  }

  auto_strip_attributes :import_admitted_notice_number,
                        :goods_declaration_number,
                        :item_number,
                        :lot_number

  def update_cache_columns!
    update!(quantity: location_variants.sum(:quantity))
  end

  def update_item_on_hand_count!
    item.update_on_hand_count!
    item.update_available_count!
  end
end
