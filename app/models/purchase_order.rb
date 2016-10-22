# == Schema Information
#
# Table name: orders
#
#  id                     :integer          not null, primary key
#  company_id             :integer          not null
#  partner_id             :integer
#  currency_id            :integer
#  payment_method_id      :integer
#  assignee_id            :integer
#  bill_to_location_id    :integer
#  ship_from_location_id  :integer
#  ship_to_location_id    :integer
#  type                   :string
#  order_number           :string
#  state                  :string
#  status                 :string
#  email                  :string
#  tax_treatment          :integer          default("exclusive"), not null
#  total_units            :integer
#  subtotal               :decimal(12, 2)
#  total_tax              :decimal(12, 2)
#  total_amount           :decimal(12, 2)
#  paid_on                :date
#  expected_delivery_date :date
#  notes                  :text
#  extra_info             :jsonb
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_orders_on_assignee_id   (assignee_id)
#  index_orders_on_company_id    (company_id)
#  index_orders_on_order_number  (order_number)
#  index_orders_on_partner_id    (partner_id)
#  index_orders_on_state         (state)
#  index_orders_on_status        (status)
#  index_orders_on_type          (type)
#

class PurchaseOrder < Order
  store_accessor :extra_info,
                 :goods_declaration_number

  after_initialize :setup_defaults
  # before_save :update_total_amount
  # after_save :update_item_available_count!

  # has_many :details, class_name: 'PurchaseOrderDetail'
  # has_many :items, through: :details, source: :item

  # accepts_nested_attributes_for :details, reject_if: :all_blank, allow_destroy: true
  # accepts_nested_attributes_for :items

  validates :status,
            :company_id,
            :partner_id,
            :bill_to_location_id,
            :ship_to_location_id,
            presence: true

  validates :order_number, presence: true, uniqueness: { scope: [:company_id, :type] }

  auto_strip_attributes :email, :notes, :order_number

  VALID_STATUSES = %w(draft active received)
  validates :status, inclusion: { in: VALID_STATUSES }

  enum tax_treatment: { exclusive: 0, inclusive: 1 }

  def self.next_number(company_id)
    where(company_id: company_id).maximum(:order_number).try(:next) || 'PO0001'
  end

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
