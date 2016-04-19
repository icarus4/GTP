# == Schema Information
#
# Table name: purchase_orders
#
#  id                  :integer          not null, primary key
#  company_id          :integer
#  supplier_id         :integer
#  bill_to_location_id :integer
#  ship_to_location_id :integer
#  status              :integer          default(0), not null
#  due_on              :date
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  order_number        :string(64)
#  contact_email       :string(64)
#  notes               :text
#

class PurchaseOrder < ActiveRecord::Base
  after_initialize :setup_defaults

  belongs_to :company
  belongs_to :supplier
  belongs_to :bill_to, class_name: 'Location', foreign_key: :bill_to_location_id
  belongs_to :ship_to, class_name: 'Location', foreign_key: :ship_to_location_id
  has_many :details, class_name: 'PurchaseOrderDetail'
  has_many :variants, through: :details, source: :variant

  accepts_nested_attributes_for :details, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :variants

  enum status: {
    draft: 0,
    active: 1,
    received: 2
  }

  validates :status,
            :company_id,
            :supplier_id,
            :bill_to_location_id,
            :ship_to_location_id,
            :due_on, presence: true

  validates :order_number, presence: true, uniqueness: { scope: :company_id }


  private


    def setup_defaults
      self.order_number ||= (self.class.where(company_id: company_id).maximum(:order_number).try(:next) || 'PO0001') if company_id
      self.status ||= 0
    end
end
