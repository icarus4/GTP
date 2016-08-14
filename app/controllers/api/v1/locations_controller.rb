class Api::V1::LocationsController < Api::V1::BaseController
  def index
    locations = current_company.locations
                               .select(:id, :name, :address, :city_id, :holds_stock)
                               .includes(:bin_locations, :city)
                               .order(:id)

    render json: { locations: locations.as_json(include: [:bin_locations, :city]) }
  end

  def holds_stock
    locations = current_company.locations
                               .select(:id, :name, :address, :city_id, :holds_stock)
                               .holds_stock
                               .includes(:bin_locations, :city)
                               .order(:id)

    render json: { locations: locations.as_json(include: [:bin_locations, :city]) }
  end
end
