# == Schema Information
#
# Table name: purchase_orders
#
#  id                  :integer          not null, primary key
#  company_id          :integer
#  supplier_id         :integer
#  bill_to_location_id :integer
#  ship_to_location_id :integer
#  status              :string
#  total_amount        :integer
#  due_on              :date
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  order_number        :string(64)
#  contact_email       :string(64)
#  notes               :text
#

class PurchaseOrder < ActiveRecord::Base
  after_initialize :setup_defaults
  after_save :update_variant_available_count

  belongs_to :company
  belongs_to :supplier
  belongs_to :bill_to, class_name: 'Location', foreign_key: :bill_to_location_id
  belongs_to :ship_to, class_name: 'Location', foreign_key: :ship_to_location_id
  has_many :details, class_name: 'PurchaseOrderDetail'
  has_many :variants, through: :details, source: :variant

  accepts_nested_attributes_for :details, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :variants

  validates :status,
            :company_id,
            :supplier_id,
            :bill_to_location_id,
            :ship_to_location_id,
            :due_on, presence: true

  validates :order_number, presence: true, uniqueness: { scope: :company_id }

  def update_total_amount
    self.total_amount = details.inject(0) { |total_amount, detail| total_amount + detail.cost_per_unit * detail.quantity }
    save
  end

  def update_variant_available_count
    variants.each(&:update_available_count!)
  end

  def active?
    status == 'active'
  end

  def active!
    self.status = 'active'
    save!
  end

  private

    def setup_defaults
      self.order_number ||= (self.class.where(company_id: company_id).maximum(:order_number).try(:next) || 'PO0001') if company_id
      self.status ||= 'active'
    end
end
