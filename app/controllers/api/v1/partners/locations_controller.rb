class Api::V1::Partners::LocationsController < Api::V1::BaseController
  before_action :find_partner

  def index
    if @partner.nil?
      render json: { errors: 'Partner not found' }, status: :bad_request and return
    end
    render json: { locations: @partner.locations }
  end

  def update
    if @partner.nil?
      render json: { errors: 'Partner not found' }, status: :bad_request and return
    end

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

  private

    def find_partner
      @partner = current_company.partners.find_by(id: params[:partner_id])
    end

    def location_params
      params.permit(:name, :address, :phone, :email)
    end
end
