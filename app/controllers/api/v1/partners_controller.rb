class Api::V1::PartnersController < Api::V1::BaseController
  def show
    partner = Partner.includes(:roles).find_by(company: current_company, id: params[:id])
    if partner.nil?
      render json: { errors: 'Partner not found' }, status: :bad_request and return
    end

    render json: { partner: partner.as_json(except: :settings).merge!({ roles: partner.roles.map(&:name) }).merge!(partner.settings) }
  end

  def create
    partner = Partner.new(create_partner_params)
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

  def update
    partner = Partner.find_by(company: current_company, id: params[:id])
    if partner.nil?
      render json: { errors: 'Partner not found' }, status: :bad_request
    end

    begin
      ActiveRecord::Base.transaction do
        if partner.update(update_partner_params)
          partner.roles = PartnerRole.where(name: params[:roles])
          render json: { partner: partner } and return
        else
          render json: { partner: partner }, status: :bad_request and return
        end
      end
    rescue => e
      render json: { errors: e.to_s }, status: :bad_request
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

    def create_partner_params
      params.permit(
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
        :default_sales_payment_method_id,    # FIXME: will be stored as string
        :default_purchase_payment_method_id, # FIXME: will be stored as string
        :default_sales_payment_term_id,      # FIXME: will be stored as string
        :default_purchase_payment_term_id,   # FIXME: will be stored as string
        :default_tax_type_id,                # FIXME: will be stored as string
        :default_receiving_location_id,      # FIXME: will be stored as string
      )
    end

    def update_partner_params
      params.permit(
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
        :default_sales_payment_method_id,    # FIXME: will be stored as string
        :default_purchase_payment_method_id, # FIXME: will be stored as string
        :default_sales_payment_term_id,      # FIXME: will be stored as string
        :default_purchase_payment_term_id,   # FIXME: will be stored as string
        :default_tax_type_id,                # FIXME: will be stored as string
        :default_receiving_location_id,      # FIXME: will be stored as string
      )
    end

    def location_params
      params.require(:location).permit(:name, :email, :phone, :address)
    end
end
