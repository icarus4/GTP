class Api::V1::PaymentTermsController < Api::V1::BaseController
  def index
    payment_terms = current_company.payment_terms.select(:id, :name, :start_from, :due_in_days)
    @payment_terms = payment_terms.map do |t|
      {
        id: t.id,
        name: t.name,
        start_from: t.start_from,
        due_in_days: t.due_in_days,
        full_name_in_chinese: t.full_name_in_chinese,
      }
    end
    render json: { payment_terms: @payment_terms }
  end
end
