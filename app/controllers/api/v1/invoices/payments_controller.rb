class Api::V1::Invoices::PaymentsController < Api::V1::BaseController
  def create
    invoice = SalesOrder::Invoice.joins(:sales_order).where(sales_orders: { company_id: current_company.id }, id: params[:invoice_id]).first
    if invoice.nil?
      render json: { errors: 'Invoice not found' }, status: :bad_request and return
    end

    payment = invoice.payments.build(payment_params)
    if payment.save
      render json: { payment: payment }
    else
      render json: { errors: payment.errors }, status: :bad_request
    end
  end

  private

    def payment_params
      params.require(:payment).permit(:payment_method_id, :amount, :receipt_date, :transfer_in_account, :transfer_out_account)
    end
end
