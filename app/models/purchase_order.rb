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
  before_save :update_total_amount
  after_save :update_item_available_count!

  belongs_to :company
  belongs_to :supplier
  belongs_to :bill_to, class_name: 'Location', foreign_key: :bill_to_location_id
  belongs_to :ship_to, class_name: 'Location', foreign_key: :ship_to_location_id
  has_many :details, class_name: 'PurchaseOrderDetail'
  has_many :items, through: :details, source: :item

  accepts_nested_attributes_for :details, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :items

  validates :status,
            :company_id,
            :supplier_id,
            :bill_to_location_id,
            :ship_to_location_id,
            :due_on, presence: true

  validates :order_number, presence: true, uniqueness: { scope: :company_id }

  VALID_STATUSES = %w(draft active received)
  validates :status, inclusion: { in: VALID_STATUSES }

  def update_total_amount
    self.total_amount = details.inject(0) { |total_amount, detail| total_amount + detail.unit_price * detail.quantity }
  end

  def update_item_available_count!
    items.each(&:update_available_count!)
  end

  def active?
    status == 'active'
  end

  def approve!
    # raise "Only draft order can be approved." unless draft?
    # self.status = 'active'
    # save!
    raise NotImplementedError
  end

  def draft?
    status == 'draft'
  end

  def received?
    status == 'received'
  end

  def receive!
    raise "Only active order can receive." unless active?

    ActiveRecord::Base.transaction do
      details.each do |detail|
        variant = Variant.find_or_initialize_by(item_id: detail.item_id, expiry_date: detail.expiry_date)
        variant.with_lock do
          variant.quantity += detail.quantity
          variant.save!
        end

        lv = LocationVariant.find_or_initialize_by(company_id: company_id, location_id: ship_to_location_id, variant_id: variant.id)
        lv.with_lock do
          lv.quantity += detail.quantity
          lv.save!
        end
      end
      self.status = 'received'
      save!
    end
  end

  private

    def setup_defaults
      self.order_number ||= (self.class.where(company_id: company_id).maximum(:order_number).try(:next) || 'PO0001') if company_id
      self.status ||= 'active'
    end
end
