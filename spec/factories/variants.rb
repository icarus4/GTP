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
#  committed_quantity            :integer          default(0), not null
#  sellable_quantity             :integer          default(0), not null
#
# Indexes
#
#  index_variants_on_expiry_date                    (expiry_date)
#  index_variants_on_goods_declaration_number       (goods_declaration_number)
#  index_variants_on_import_admitted_notice_number  (import_admitted_notice_number)
#  index_variants_on_item_id                        (item_id)
#  index_variants_on_procurement_id                 (procurement_id)
#

FactoryGirl.define do
  factory :variant do
    item
    quantity { rand(1..10) }
    expiry_date { rand(120).days.from_now }
  end
end
