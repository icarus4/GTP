class Api::V1::ManufacturersController < Api::V1::BaseController
  def index
    render json: { manufacturers: current_company.manufacturers.order(:id) }
  end

  def create
    # Reason of &.strip&.presence:
    # Convert "" or " " to nil
    # Convert "a" or "a " to "a"
    manufacturer = current_company.partners.build(manufacturer_params)
    if manufacturer.save
      manufacturer.roles << PartnerRole.find_by!(name: 'manufacturer')
      render json: { manufacturer: manufacturer }
    else
      render json: { errors: manufacturer.errors.full_messages }, status: :bad_request
    end
  end

  private

    def manufacturer_params
      params.permit(:name, :alias_name, :partner_type, :factory_registration_number)
    end
end
