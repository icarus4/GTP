class Api::V1::ManufacturersController < Api::V1::BaseController
  def index
    render json: { manufacturers: current_company.manufacturers.order(:id) }
  end

  def create
    registration_number = params[:registration_number].present? ? params[:registration_number].strip : nil
    address = params[:address].present? ? params[:address].strip : nil
    location_type = params[:location_type]

    # TODO: validate location_type

    manufacturer = current_company.manufacturers.build(
      name: params[:name].strip,
      registration_number: registration_number,
      location_type: location_type,
      address: address,
    )
    if manufacturer.save
      render json: { manufacturer: manufacturer }
    else
      render json: { errors: manufacturer.errors }, status: :bad_request
    end
  end
end