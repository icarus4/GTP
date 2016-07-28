# == Schema Information
#
# Table name: locations
#
#  id                :integer          not null, primary key
#  locationable_id   :integer
#  locationable_type :string
#  city_id           :integer
#  zip               :string(8)
#  address           :string(255)
#  name              :string(255)
#  holds_stock       :boolean          default(TRUE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Location < ActiveRecord::Base
  belongs_to :city
  belongs_to :locationable, polymorphic: true
  has_many :bin_locations
  has_many :location_variants, through: :bin_locations
  has_many :variants, through: :location_variants

  validates :city_id, presence: true
  validates :address, presence: true
  validates :name,    presence: true

  scope :holds_stock, -> { where(holds_stock: true) }

  def holds_stock?
    holds_stock
  end
end
