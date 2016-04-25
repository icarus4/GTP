# == Schema Information
#
# Table name: stock_transfers
#
#  id                      :integer          not null, primary key
#  company_id              :integer
#  source_location_id      :integer
#  destination_location_id :integer
#  status                  :string(32)       not null
#  order_number            :string(64)
#  expected_transfer_date  :date
#  transferred_at          :datetime
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class StockTransfer < ActiveRecord::Base
  after_initialize :setup_defaults

  belongs_to :company
  belongs_to :source_location,      class_name: 'Location'
  belongs_to :destination_location, class_name: 'Location'

  has_many :details, class_name: 'StockTransferDetail'
  has_many :variants, through: :details, source: :variant

  accepts_nested_attributes_for :details, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :variants

  validates :company_id,
            :source_location_id,
            :destination_location_id,
            :status,
            :expected_transfer_date,
            :order_number, presence: true


  AVAILABLE_STATUS = %w(
    active
    received
  )


  private


    def setup_defaults
      self.order_number ||= (self.class.where(company_id: company_id).maximum(:order_number).try(:next) || 'ST0001') if company_id
      self.status ||= 'active'
    end
end
