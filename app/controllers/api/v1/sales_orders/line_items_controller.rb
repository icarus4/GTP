class Api::V1::SalesOrders::LineItemsController < Api::V1::BaseController
  def index
    sales_order = SalesOrder.find_by(company: current_company, id: params[:sales_order_id])
    if sales_order.blank?
      render json: { errors: 'Sales order not found' }, status: :not_found and return
    end

    line_items = sales_order.line_items.includes(:item).order(:id)
    render json: { sales_order_line_items: line_items.as_json(include: :item) }
  end
end
