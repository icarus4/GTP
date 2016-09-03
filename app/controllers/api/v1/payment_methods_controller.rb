class Api::V1::PaymentMethodsController < Api::V1::BaseController
  def index
    payment_methods = current_company.payment_methods.select(:id, :name)
    @payment_methods = payment_methods.map do |pm|
      {
        id:      pm.id,
        name:    pm.name,
        default: pm.default?(current_company)
      }
    end
    render json: { payment_methods: @payment_methods }
  end

  def update
    payment_method = PaymentMethod.find_by(company: current_company, id: params[:id])
    if payment_method.blank?
      render json: { errors: 'Payment method not found' }, status: :bad_request
    end

    if payment_method.update(payment_method_params)
      current_company.update(default_payment_method_id: payment_method.id)
      render json: { payment_method: payment_method }
    else
      render json: { errors: payment_method.errors.full_messages }, status: :bad_request
    end
  end

  private

    def payment_method_params
      params.permit(:name)
    end
end
