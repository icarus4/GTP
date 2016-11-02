class Api::V1::PurchaseOrders::LineItemsController < Api::V1::BaseController
  def index
    purchase_order = PurchaseOrder.find_by(company: current_company, id: params[:purchase_order_id])
    if purchase_order.blank?
      render json: { errors: 'Purchase order not found' }, status: :bad_request and return
    end

    line_items = purchase_order.line_items.includes(:item).order(:id)
    render json: { purchase_order_line_items: line_items.as_json(include: :item) }
  end

  def unprocured
    purchase_order = PurchaseOrder.find_by(company: current_company, id: params[:purchase_order_id])
    if purchase_order.blank?
      render json: { errors: 'Purchase order not found' }, status: :bad_request and return
    end

    line_items = purchase_order.line_items.unprocured.includes(:item).order(:id)
    render json: { purchase_order_line_items: line_items.as_json(include: :item) }
  end
end
