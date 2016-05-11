# == Schema Information
#
# Table name: sales_orders
#
#  id                    :integer          not null, primary key
#  company_id            :integer
#  customer_id           :integer
#  bill_to_location_id   :integer
#  ship_to_location_id   :integer
#  ship_from_location_id :integer
#  assignee_id           :integer
#  status                :string
#  total_amount          :integer
#  issued_on             :date
#  shipped_on            :date
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  order_number          :string(64)
#  contact_email         :string(64)
#  notes                 :text
#

class SalesOrder < ActiveRecord::Base
  after_initialize :setup_defaults
  before_save :update_total_amount
  after_save :update_variant_available_count

  belongs_to :company
  belongs_to :customer
  belongs_to :bill_to, class_name: 'Location', foreign_key: :bill_to_location_id
  belongs_to :ship_to, class_name: 'Location', foreign_key: :ship_to_location_id
  belongs_to :ship_from, class_name: 'Location', foreign_key: :ship_from_location_id
  has_many :details, class_name: 'SalesOrderDetail'
  has_many :variants, through: :details, source: :variant

  accepts_nested_attributes_for :details, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :variants

  validates :status,
            :company_id,
            :customer_id,
            :bill_to_location_id,
            :ship_to_location_id,
            :ship_from_location_id,
            :shipped_on, presence: true

  validates :status, inclusion: { in: %w(draft active finalized fulfilled) }

  def draft?
    status == 'draft'
  end

  def active?
    status == 'active'
  end

  def finalized?
    status == 'finalized'
  end

  def fulfilled?
    status == 'fulfilled'
  end

  def update_total_amount
    self.total_amount = details.inject(0) { |total_amount, detail| total_amount + detail.cost_per_unit * detail.quantity }
  end

  def update_variant_available_count
    variants.each(&:update_available_count!)
  end

  private

    def setup_defaults
      self.order_number ||= (self.class.where(company_id: company_id).maximum(:order_number).try(:next) || 'SO0001') if company_id
      self.status ||= 'active'
    end
end
