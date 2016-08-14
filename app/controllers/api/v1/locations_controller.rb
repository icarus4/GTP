class Api::V1::LocationsController < Api::V1::BaseController
  def index
    locations = current_company.locations#.includes(:bin_locations)
    render json: { locations: locations }
  end
end
