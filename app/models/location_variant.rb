# == Schema Information
#
# Table name: location_variants
#
#  id          :integer          not null, primary key
#  company_id  :integer
#  location_id :integer
#  variant_id  :integer
#  quantity    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class LocationVariant < ActiveRecord::Base
  belongs_to :company
  belongs_to :location
  belongs_to :variant

  after_save :update_variant_cache_data!
  after_initialize :setup_defaults

  validates :company_id, :location_id, :variant_id, :quantity, presence: true
  validates :location_id, uniqueness: { scope: :variant_id }

  private

    def update_variant_cache_data!
      variant.update_cache_columns!
    end

    def setup_defaults
      self.quantity ||= 0
    end
end
