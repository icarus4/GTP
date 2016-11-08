class Api::V1::ProcurementsController < Api::V1::BaseController
  def destroy
    procurement = Procurement.joins(:purchase_order).find_by(orders: { company_id: current_company.id }, id: params[:id])
    if procurement.nil?
      render json: { errors: 'Procurement not found' }, status: :bad_request and return
    end

    Procurements::VoidProcurementService.call(procurement)
    render nothing: true, status: :no_content
  end
end
