class Api::V1::BinLocationsController < Api::V1::BaseController
  def create
    location = Location.find_by(locationable: current_company, id: params[:location_id])
    if location.blank?
      render json: { errors: "Location not found" }, status: :bad_request and return
    end

    bin_location = location.bin_locations.build(name: params[:name])
    if bin_location.save
      render json: { bin_location: bin_location }
    else
      render json: { errors: bin_location.errors }, status: :bad_request
    end
  end
end
