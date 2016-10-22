class Api::V1::PurchaseOrdersController < Api::V1::BaseController
  def next_number
    render json: { next_number: PurchaseOrder.next_number(current_company.id) }
  end

  def create
    partner = Partner.find_by(company: current_company, id: params[:partner_id])

    if partner.blank?
      render json: { errors: "Partner not found" }, status: :bad_request and return
    end

    purchase_order = current_company.purchase_orders.build(purchase_order_params)
    purchase_order.partner = partner

    if purchase_order.save
      render json: { purchase_order: purchase_order.as_json }
    else
      render json: { errors: purchase_order.errors }, status: :bad_request
    end
  end

  private

    def purchase_order_params
      params.permit(
        :bill_to_location_id,
        :ship_to_location_id,
        :tax_treatment,
        :email,
        :expected_delivery_date,
        :notes,
      )
    end
end
