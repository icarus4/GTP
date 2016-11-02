class Api::V1::Locations::BinLocationsController < Api::V1::BaseController
  def index
    location = Location.find_by(locationable: current_company, id: params[:location_id])
    if location.nil?
      render json: { errors: "Location not found" }, status: :bad_request and return
    end

    render json: { bin_locations: location.bin_locations }
  end

  def create
    location = Location.find_by(locationable: current_company, id: params[:location_id])
    if location.nil?
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
