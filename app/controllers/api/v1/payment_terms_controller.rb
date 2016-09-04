class Api::V1::PaymentTermsController < Api::V1::BaseController
  def index
    payment_terms = current_company.payment_terms.select(:id, :company_id, :name, :start_from, :due_in_days).order(:id)
    @payment_terms = payment_terms.map do |pt|
      {
        id:                   pt.id,
        name:                 pt.name,
        start_from:           pt.start_from,
        due_in_days:          pt.due_in_days,
        full_name_in_chinese: pt.full_name_in_chinese,
        default:              pt.default?(current_company),
      }
    end
    render json: { payment_terms: @payment_terms }
  end

  def update
    payment_term = PaymentTerm.find_by(company: current_company, id: params[:id])
    if payment_term.blank?
      render json: { errors: 'Payment term not found' }, status: :bad_request
    end

    if payment_term.update(payment_term_params)
      current_company.update(default_payment_term_id: payment_term.id) if params[:default].try(:to_bool)
      render json: { payment_term: payment_term }
    else
      render json: { errors: payment_term.errors.full_messages }, status: :bad_request
    end
  end

  def create
    payment_term = PaymentTerm.new(payment_term_params)
    payment_term.company = current_company

    if payment_term.save
      current_company.update(default_payment_term_id: payment_term.id) if params[:default].try(:to_bool)
      render json: { payment_term: payment_term }
    else
      render json: { errors: payment_term.errors.full_messages }, status: :bad_request
    end
  end

  private

    def payment_term_params
      params.permit(:name, :due_in_days, :start_from)
    end
end
