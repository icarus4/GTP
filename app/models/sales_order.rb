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

  belongs_to :company
  belongs_to :customer
  belongs_to :bill_to, class_name: 'Location', foreign_key: :bill_to_location_id
  belongs_to :ship_to, class_name: 'Location', foreign_key: :ship_to_location_id
  belongs_to :ship_from, class_name: 'Location', foreign_key: :ship_from_location_id
  has_many :details, class_name: 'SalesOrderDetail'
  has_many :variants, through: :details, source: :variant

  validates :status,
            :company_id,
            :customer_id,
            :bill_to_location_id,
            :ship_to_location_id,
            :ship_from_location_id,
            :shipped_on, presence: true

  VALID_STATUSES = %w(draft active finalized fulfilled)
  validates :status, inclusion: { in: VALID_STATUSES }
  validates :order_number, presence: true, uniqueness: { scope: :company_id }


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
    self.total_amount = details.inject(0) { |total_amount, detail| total_amount + detail.unit_price * detail.quantity }
  end

  def update_total_amount!
    update_total_amount
    save!
  end

  def update_item_available_count!
    items = variants.map { |v| v.item }.uniq
    items.each(&:update_available_count!)
  end

  def self.next_number(company_id)
    where(company_id: company_id).maximum(:order_number).try(:next) || 'SO0001'
  end

  def ship!
    raise "Only active order can ship." unless active?
    ActiveRecord::Base.transaction do
      details.each do |detail|
        variant = detail.variant
        variant.with_lock do
          variant.quantity -= detail.quantity
          variant.save!
        end

        lv = LocationVariant.find_or_initialize_by(company_id: company_id, location_id: ship_from_location_id, variant_id: variant.id)
        lv.with_lock do
          lv.quantity -= detail.quantity
          lv.save!
        end
      end

      self.status = 'fulfilled'
      save!
    end
  end

  private

    def setup_defaults
      self.order_number ||= self.class.next_number(company_id)
      self.status ||= 'active'
    end
end
