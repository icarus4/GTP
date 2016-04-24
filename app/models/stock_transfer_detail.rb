# == Schema Information
#
# Table name: stock_transfer_details
#
#  id                :integer          not null, primary key
#  stock_transfer_id :integer
#  variant_id        :integer
#  quantity          :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class StockTransferDetail < ActiveRecord::Base
  belongs_to :stock_transfer
  belongs_to :variant
  
  accepts_nested_attributes_for :variant, :reject_if => :all_blank
end
