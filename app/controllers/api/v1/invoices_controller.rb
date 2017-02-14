class Api::V1::InvoicesController < Api::V1::BaseController
  def destroy
    invoice = SalesOrder::Invoice.joins(:sales_order).where(sales_orders: { company_id: current_company.id }, id: params[:id]).first
    if invoice.nil?
      render json: { errors: 'Invoice not found' }, status: :bad_request and return
    end

    invoice.destroy
    render json: { invoice: invoice }
  end
end
