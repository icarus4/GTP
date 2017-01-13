class Api::V1::SalesOrders::ShipmentsController < Api::V1::BaseController
  # 根據 sales order line item commitments 的內容，降低商品庫存
  def create
    sales_order = SalesOrder.find_by(company: current_company, id: params[:sales_order_id])
    render json: { errors: 'Sales order not found' }, status: :bad_request and return if sales_order.nil?

    shipment = nil
    begin
      ActiveRecord::Base.transaction do
        shipment = sales_order.shipments.create!(shipped_at: Time.zone.now) # TODO: 可讓 user 輸入 shipped_at
        sales_order.line_item_commitments.each do |line_item_commitment|
          line_item_commitment.ship!(shipment)
        end
      end
    rescue => e
      render json: { errors: e.message }, status: :bad_request and return
    end

    sales_order.update_status!

    render json: { shipment: shipment }
  end
end
