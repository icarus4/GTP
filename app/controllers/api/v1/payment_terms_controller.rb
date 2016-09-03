class Api::V1::PaymentTermsController < Api::V1::BaseController
  def index
    payment_terms = current_company.payment_terms.select(:id, :company_id, :name, :start_from, :due_in_days)
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
end
