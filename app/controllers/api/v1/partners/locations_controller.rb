class Api::V1::Partners::LocationsController < Api::V1::BaseController
  before_action :find_partner

  def index
    render json: { locations: @partner.locations.order(:id) }
  end

  def update
    location = @partner.locations.find_by(id: params[:id])
    if location.nil?
      render json: { errors: 'Location not found' }, status: :bad_request and return
    end

    if location.update(location_params)
      render json: { location: location }
    else
      render json: { errors: location.errors.full_messages }, status: :bad_request
    end
  end

  def create
    location = @partner.locations.build(location_params)
    if location.save
      render json: { location: location }
    else
      render json: { errors: location.errors.full_messages }, status: :bad_request
    end
  end

  private

    def find_partner
      @partner = current_company.partners.find_by(id: params[:partner_id])
      render json: { errors: 'Partner not found' }, status: :bad_request and return unless @partner
    end

    def location_params
      params.permit(:name, :address, :phone, :email)
    end
end
