# == Schema Information
#
# Table name: items
#
#  id           :integer          not null, primary key
#  company_id   :integer
#  supplier_id  :integer
#  item_type_id :integer
#  brand_id     :integer
#  status       :integer          default(0), not null
#  name         :string(255)      default(""), not null
#  unit         :string
#  description  :text
#  deleted_at   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

module ItemsHelper
end
