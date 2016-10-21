class Api::V1::PurchaseOrdersController < Api::V1::BaseController
  def next_number
    render json: { next_number: PurchaseOrder.next_number(current_company.id) }
  end

  def create
    partner = Partner.find_by(company: current_company, id: params[:partner_id])

    if partner.blank?
      render json: { errors: "Partner not found" }, status: :bad_requrest and return
    end

    po = current_company.purchase_orders.build(purchase_order_params)
    po.partner = partner

    if po.save
      render json: { purchase_order: po.as_json }
    else
      render json: { errors: po.errors }, status: :bad_requrest
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
