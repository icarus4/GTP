# == Schema Information
#
# Table name: locations
#
#  id                :integer          not null, primary key
#  locationable_type :string
#  locationable_id   :integer
#  city_id           :integer
#  zip               :string(8)
#  phone             :string(32)
#  email             :string(64)
#  address           :string(255)
#  name              :string(255)
#  holds_stock       :boolean          default(FALSE), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_locations_on_locationable_type_and_locationable_id  (locationable_type,locationable_id)
#

class Location < ApplicationRecord
  belongs_to :city
  belongs_to :locationable, polymorphic: true

  validates :locationable_type, presence: true
  validates :locationable_id, presence: true
  validates :address, presence: true
  validates :name,    presence: true, uniqueness: { scope: [:locationable_type, :locationable_id] }

  auto_strip_attributes :name, :email, :address, :phone

  scope :holds_stock, -> { where(holds_stock: true) }

  def holds_stock?
    holds_stock
  end

  def full_name
    "#{name} (#{address})"
  end
end
