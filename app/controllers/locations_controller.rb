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

class LocationsController < ApplicationController
  def index
  end

  def new
    @location = current_company.locations.build
  end

  def create
    @location = current_company.locations.build(location_params)

    if @location.save
      redirect_to locations_path
    else
      render :new
    end
  end


  private


    def location_params
      params.require(:location).permit(:name, :zip, :city_id, :address, :holds_stock, :locationable_type, :locationable_id)
    end
end
