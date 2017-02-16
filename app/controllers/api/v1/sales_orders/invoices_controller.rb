class Api::V1::SalesOrders::InvoicesController < Api::V1::BaseController
  def index
    sales_order = SalesOrder.find_by(company: current_company, id: params[:sales_order_id])

    if sales_order.nil?
      render json: { errors: 'Sales order not found' }, status: :bad_request and return
    end

    render json: { invoices: sales_order.invoices.order(:created_at) }
  end

  def create
    sales_order = SalesOrder.find_by(company: current_company, id: params[:sales_order_id])

    if sales_order.nil?
      render json: { errors: 'Sales order not found' }, status: :bad_request and return
    end

    # 目前僅提供一次 invoice 全部的方式，暫不提供分批 invoice
    if sales_order.invoices.exists?
      render json: { errors: 'Invoice already exists' }, status: :bad_request and return
    end

    invoice = sales_order.invoices.build(invoice_params)
    invoice.invoiced_on = Time.zone.today if invoice.invoiced_on.blank?

    # 檢查輸入的 payment term 是否為此公司所有
    if invoice.payment_term && invoice.payment_term.company_id != current_company.id
      render json: { errors: 'Invalid payment term' }, status: :bad_request and return
    end

    ActiveRecord::Base.transaction do
      unless invoice.save
        render json: { errors: invoice.errors }, status: :bad_request and return
      end
      invoice.invoice_all!
    end

    render json: { invoice: invoice }
  end

  private

    def invoice_params
      params.require(:invoice).permit(:invoiced_on, :due_on, :payment_term_id, :notes)
    end
end
