# == Schema Information
#
# Table name: location_variants
#
#  id              :integer          not null, primary key
#  company_id      :integer
#  bin_location_id :integer
#  variant_id      :integer
#  quantity        :integer          default(0), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_location_variants_on_bin_location_id  (bin_location_id)
#  index_location_variants_on_company_id       (company_id)
#  index_location_variants_on_variant_id       (variant_id)
#

class LocationVariant < ActiveRecord::Base
  belongs_to :company
  belongs_to :bin_location
  belongs_to :variant

  after_save :update_variant_cache_data!
  after_initialize :setup_defaults

  validates :company_id, :variant_id, :quantity, presence: true
  validates :bin_location_id, presence: true, uniqueness: { scope: :variant_id }

  private

    def update_variant_cache_data!
      variant.update_cache_columns!
    end

    def setup_defaults
      self.quantity ||= 0
    end
end
