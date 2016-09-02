class Api::V1::PaymentMethodsController < Api::V1::BaseController
  def index
    payment_methods = current_company.payment_methods.select(:id, :name)
    render json: { payment_methods: payment_methods }
  end
end
