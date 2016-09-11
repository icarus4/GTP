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

class Location < ActiveRecord::Base
  belongs_to :city
  belongs_to :locationable, polymorphic: true
  has_many :bin_locations

  after_create :create_default_bin_location

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

  private

    def create_default_bin_location
      bin_locations.create(name: '預設') if holds_stock
    end
end
