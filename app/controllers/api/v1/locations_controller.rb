class Api::V1::LocationsController < Api::V1::BaseController
  def index
    locations = current_company.locations
                               .select(:id, :name, :address, :city_id, :holds_stock, :zip)
                               .includes(:city)
                               .order(:id)

    render json: { locations: locations.as_json(include: :city) }
  end

  def holds_stock
    locations = current_company.locations
                               .select(:id, :name, :address, :city_id, :holds_stock, :zip)
                               .holds_stock
                               .includes(:city)
                               .order(:id)

    render json: { locations: locations.as_json(include: :city) }
  end

  def update
    location = Location.find_by(locationable: current_company, id: params[:id])
    if location.blank?
      render json: { errors: "Location not found" }, status: :bad_request and return
    end

    location.name    = params[:name].strip
    location.address = params[:address].strip
    location.city_id = params[:city_id]
    location.zip     = params[:zip]

    if location.save
      render json: { location: location.as_json(include: :city) }
    else
      render json: { errors: location.errors }, status: :bad_request
    end
  end
end
