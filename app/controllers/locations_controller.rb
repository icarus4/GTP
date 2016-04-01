class LocationsController < ApplicationController
  def index
    @locations = current_company.locations
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
