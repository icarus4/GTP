class PurchaseOrders::PurchaseOrderReturnsController < ApplicationController
  def show
    @purchase_order = PurchaseOrder.find_by(company: current_company, id: params[:purchase_order_id])
    if @purchase_order.nil?
      redirect_to purchase_orders_path and return
    end

    @purchase_order_return = PurchaseOrderReturn.find_by(company: current_company, id: params[:id])
    if @purchase_order_return.nil?
      redirect_to purchase_order_path(@purchase_order) and return
    end
  end
end
