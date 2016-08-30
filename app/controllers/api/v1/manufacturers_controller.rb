class Api::V1::ManufacturersController < Api::V1::BaseController
  def index
    render json: { manufacturers: current_company.manufacturers.order(:id) }
  end

  def create
    raise NotImplementedError, 'FIXME'
    # Reason of &.strip&.presence:
    # Convert "" or " " to nil
    # Convert "a" or "a " to "a"
    registration_number = params[:registration_number]&.strip&.presence
    address             = params[:address]&.strip&.presence
    # TODO: validate location_type

    manufacturer = current_company.manufacturers.build(
      name:                params[:name].strip,
      registration_number: registration_number,
      location_type:       params[:location_type],
      address:             address,
    )
    if manufacturer.save
      render json: { manufacturer: manufacturer }
    else
      render json: { errors: manufacturer.errors }, status: :bad_request
    end
  end
end
