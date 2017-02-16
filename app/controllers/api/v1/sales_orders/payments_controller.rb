class Api::V1::SalesOrders::PaymentsController < Api::V1::BaseController
  def index
    sales_order = SalesOrder.find_by(company: current_company, id: params[:sales_order_id])

    if sales_order.nil?
      render json: { errors: 'Sales order not found' }, status: :bad_request
    else
      render json: { payments: sales_order.payments.order(:created_at) }
    end
  end
end
