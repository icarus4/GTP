class Api::V1::PaymentsController < Api::V1::BaseController
  def destroy
    payment = SalesOrder::Payment.joins(:sales_order).where(sales_orders: { company_id: current_company.id }, id: params[:id]).first

    if payment.nil?
      render json: { errors: 'Payment not found' }, status: :bad_request and return
    end

    if payment.destroy
      render json: { payment: payment }
    else
      render json: { errors: payment.errors }, status: :bad_request
    end
  end
end
