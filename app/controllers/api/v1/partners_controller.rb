class Api::V1::PartnersController < Api::V1::BaseController
  def create
    partner = Partner.new(
      company: current_company,
      partner_type:  params[:partner_type],
      receipt_type:  params[:receipt_type],
      name:          params[:name],
      alias_name:    params[:alias_name],
      email:         params[:email],
      tax_number:    params[:tax_number],
      phone:         params[:phone],
      fax:           params[:fax],
      food_industry_registration_number:           params[:food_industry_registration_number],
      no_food_industry_registration_number_reason: params[:no_food_industry_registration_number_reason],
      factory_registration_number:                 params[:factory_registration_number],
      website:       params[:website],
      description:   params[:description],
    )

    error_message = nil
    begin
      ActiveRecord::Base.transaction do
        partner.save!
        partner.roles = PartnerRole.where(name: params[:roles])
        location = partner.locations.build(
          name:    params[:location][:name],
          email:   params[:location][:email],
          phone:   params[:location][:phone],
          address: params[:location][:address],
        )
        location.save!
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
      render json: { errors: 'Partner not found' }, status: :bad_request and return
    end
    render json: { locations: partner.locations }
  end
end
