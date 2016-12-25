class Api::V1::ProcurementsController < Api::V1::BaseController
  def update
    procurement = Procurement.joins(:purchase_order).find_by(purchase_orders: { company_id: current_company.id }, id: params[:id])
    if procurement.nil?
      render json: { errors: 'Procurement not found' }, status: :bad_request and return
    end

    procured_on = Date.strptime(params[:procurement][:procured_on], "%Y-%m-%d") rescue nil
    if procured_on
      procurement.update!(procured_at: procured_on)
      render json: { procurement: procurement }
    else
      render json: { errors: 'Invalid date' }, status: :bad_request
    end
  end

  def destroy
    procurement = Procurement.joins(:purchase_order).find_by(purchase_orders: { company_id: current_company.id }, id: params[:id])
    if procurement.nil?
      render json: { errors: 'Procurement not found' }, status: :bad_request and return
    end

    Procurements::VoidProcurementService.call(procurement)
    render nothing: true, status: :no_content
  end
end
