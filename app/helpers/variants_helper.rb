# == Schema Information
#
# Table name: variants
#
#  id                 :integer          not null, primary key
#  item_id            :integer          not null
#  quantity           :integer          default(0), not null
#  manufacturing_date :date
#  expiry_date        :date
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

module VariantsHelper
end
