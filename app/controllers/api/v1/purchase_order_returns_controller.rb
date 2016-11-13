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
        # 此處利用PurchaseOrderReturnLineItem的callback扣除退貨的庫存數字
        # TODO:
        # 目前先假設沒有搬移，因此直接扣掉 location_variant.quantity
        # 未來需要確認產品是否有搬移過
      end
    end

    purchase_order.update_return_status!

    render json: { purchase_order_return: purchase_order_return.as_json(include: :line_items) }
  end

  # 刪除 PurchaseOrderReturn
  def destroy
    purchase_order_return = PurchaseOrderReturn.find_by(company: current_company, id: params[:id])
    if purchase_order_return.nil?
      render json: { errors: 'Purchase order return not found' }, status: :not_found and return
    end

    purchase_order_return.destroy!
    # 此處利用 PurchaseOrderReturn 的 dependent: :destroy 刪除 PurchaseOrderReturnLineItem，
    # 再利用PurchaseOrderReturnLineItem的callback扣除退貨的庫存數字
    # TODO:
    # 目前先假設沒有搬移，因此直接加回 location_variant.quantity
    # 未來需要確認產品是否有搬移過

    purchase_order_return.purchase_order.update_return_status!

    render json: { purchase_order_return: purchase_order_return }
  end
end
