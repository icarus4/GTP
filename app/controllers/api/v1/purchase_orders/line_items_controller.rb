class Api::V1::PurchaseOrders::LineItemsController < Api::V1::BaseController
  def create
    purchase_order = PurchaseOrder.find_by(company: current_company, id: params[:purchase_order_id])

    if purchase_order.blank?
      render json: { errors: 'PurchaseOrder not found' }, status: :bad_request and return
    end

    line_item = purchase_order.line_items.build(line_item_params)
    if line_item.save
      render json: { line_item: line_item }
    else
      render json: { errors: line_item.errors }, status: :bad_request
    end
  end

  private

    def line_item_params
      params.permit(
        :item_id,
        :quantity,
        :unit_price,
        :tax_rate
      )
    end
end
