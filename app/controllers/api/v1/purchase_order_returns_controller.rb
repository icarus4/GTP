class Api::V1::PurchaseOrderReturnsController < Api::V1::BaseController
  def show
    purchase_order_return = PurchaseOrderReturn.find_by(company: current_company, id: params[:id])
    if purchase_order_return.nil?
      render json: { errors: 'Purchase order return not found' }, status: :not_found and return
    end

    render json: {
      purchase_order_return: purchase_order_return.as_json(methods: [:line_item_ids, :purchase_order_line_item_ids]),
      purchase_order_return_line_items: purchase_order_return.line_items.order(:id).as_json(
        include: [:purchase_order_line_item, :item ]
      )
    }
  end

  # 建立 PurchaseOrderReturn 以及 PurchaseOrderReturnLineItem
  def create
    purchase_order = PurchaseOrder.find_by(company: current_company, id: params[:purchase_order_id])
    if purchase_order.nil?
      render json: { errors: 'Purchase order not found' }, status: :not_found and return
    end

    purchase_order_return = nil
    ActiveRecord::Base.transaction do
      purchase_order_return = PurchaseOrderReturn.create!(company: current_company, purchase_order: purchase_order, notes: params[:notes])
      params[:purchase_order_return_line_items].each do |_, input_line_item|
        po_line_item = Order::LineItem.find_by(id: input_line_item[:id])
        next if po_line_item.nil?
        return_quantity = input_line_item[:quantity].to_i
        existing_return_quantity = PurchaseOrderReturnLineItem.where(purchase_order_line_item: po_line_item).sum(:quantity)
        return_quantity = po_line_item.quantity - existing_return_quantity if return_quantity + existing_return_quantity > po_line_item.quantity # 退貨數量(此次退貨數量+過去的退貨數量)不可比進貨數量多
        next if return_quantity <= 0 # Should not < 0, just in case.
        PurchaseOrderReturnLineItem.create!(
          purchase_order_return:    purchase_order_return,
          purchase_order_line_item: po_line_item,
          quantity:                 return_quantity,
          item_id:                  po_line_item.item_id
        )

        # 如果沒有產生任何一個 PurchaseOrderReturnLineItem，則刪除purchase_order_return
        purchase_order_return.destroy! if !purchase_order_return.line_items.exists?

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
