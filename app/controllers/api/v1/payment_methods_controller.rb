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
end
