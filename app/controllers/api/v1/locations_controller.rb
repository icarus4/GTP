class Api::V1::LocationsController < Api::V1::BaseController
  def index
    locations = current_company.locations
                               .select(:id, :name, :address)
                               .holds_stock
                               .includes(:bin_locations)
                               .order(:id)
                               
    render json: { locations: locations.as_json(include: :bin_locations) }
  end
end
