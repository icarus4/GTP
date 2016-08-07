# == Schema Information
#
# Table name: sales_order_details
#
#  id             :integer          not null, primary key
#  sales_order_id :integer
#  variant_id     :integer
#  quantity       :integer
#  unit_price     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  note           :text
#
# Indexes
#
#  index_sales_order_details_on_sales_order_id  (sales_order_id)
#  index_sales_order_details_on_variant_id      (variant_id)
#

FactoryGirl.define do
  factory :sales_order_detail do
    sales_order
    variant
    quantity { [10, 20, 50, 100, 200, 500].sample }
    unit_price { [10, 50, 100, 500, 1000].sample }
  end
end
