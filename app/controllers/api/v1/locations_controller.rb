class Api::V1::LocationsController < Api::V1::BaseController
  def index
    render json: { locations: current_company.locations }
  end
end
