class Api::V1::Partners::ContactsController < Api::V1::BaseController
  before_action :find_contact

  def index
    render json: { contacts: @partner.contacts.order(:id) }
  end

  def update
    contact = @partner.contacts.find_by(id: params[:id])
    if contact.nil?
      render json: { errors: 'Contact not found' }, status: :bad_request and return
    end

    if contact.update(contact_params)
      render json: { contact: contact }
    else
      render json: { errors: contact.errors.full_messages }, status: :bad_request
    end
  end

  def create
    contact = @partner.contacts.build(contact_params)
    if contact.save
      render json: { contact: contact }
    else
      render json: { errors: contact.errors.full_messages }, status: :bad_request
    end
  end

  private

    def find_contact
      @partner = current_company.partners.find_by(id: params[:partner_id])
      render json: { errors: 'Partner not found' }, status: :bad_request and return unless @partner
    end

    def contact_params
      params.permit(:name, :phone, :fax, :mobile, :email, :title, :department, :notes)
    end
end
