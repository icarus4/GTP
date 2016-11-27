class Api::V1::PurchaseOrders::PurchaseOrderReturnsController < Api::V1::BaseController
  def index
    purchase_order = PurchaseOrder.find_by(company: current_company, id: params[:purchase_order_id])
    if purchase_order.nil?
      render json: { errors: 'Purchase order not found' }, status: :not_found and return
    end

    render json: { purchase_order_returns: purchase_order.purchase_order_returns.order(:id).as_json(include: :line_items) }
  end
end
