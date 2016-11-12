class Api::V1::PurchaseOrderReturnsController < Api::V1::BaseController
  # 建立 PurchaseOrderReturn 以及 PurchaseOrderReturnLineItem
  def create
    purchase_order = PurchaseOrder.find_by(company: current_company, id: params[:purchase_order_id])
    if purchase_order.nil?
      render json: { errors: 'Purchase order not found' }, status: :not_found and return
    end

    purchase_order_return = nil
    ActiveRecord::Base.transaction do
      purchase_order_return = PurchaseOrderReturn.create!(company: current_company, purchase_order: purchase_order)
      params[:purchase_order_return_line_items].each do |_, input_line_item|
        line_item = Order::LineItem.find_by(id: input_line_item[:id])
        next if line_item.nil?
        quantity = input_line_item[:quantity].to_i
        quantity = line_item.quantity if quantity > line_item.quantity # 退貨數量不可比進貨數量多
        PurchaseOrderReturnLineItem.create!(
          purchase_order_return: purchase_order_return,
          line_item:             line_item,
          quantity:              quantity,
          item_id:               line_item.item_id
        )
      end
    end

    render json: { purchase_order_return: purchase_order_return.as_json(include: :line_items) }
  end
end
