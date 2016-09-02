class Api::V1::PartnersController < Api::V1::BaseController
  def create
    partner = Partner.new(partner_params)
    partner.company = current_company

    error_message = nil
    begin
      ActiveRecord::Base.transaction do
        partner.save!
        partner.roles = PartnerRole.where(name: params[:roles])
        location = partner.locations.create!(location_params)
      end
    rescue => e
      error_message = e.to_s
    end

    if error_message.nil?
      render json: { partner: partner }
    else
      render json: { errors: error_message }, status: :bad_request
    end
  end

  def locations
    partner = current_company.partners.find_by(id: params[:id])
    if partner.nil?
      render json: { errors: 'Partner not found' }, status: :bad_request
    else
      render json: { locations: partner.locations }
    end
  end

  private

    def partner_params
      params.presence_all.permit(
        :partner_type,
        :receipt_type,
        :name,
        :alias_name,
        :email,
        :tax_number,
        :phone,
        :fax,
        :food_industry_registration_number,
        :no_food_industry_registration_number_reason,
        :factory_registration_number,
        :website,
        :description,
        :default_payment_method_id,
        :default_payment_term_id,
      )
    end

    def location_params
      params.presence_all.require(:location).permit(:name, :email, :phone, :address)
    end
end
