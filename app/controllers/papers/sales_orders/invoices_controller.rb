class Papers::SalesOrders::InvoicesController < Papers::BaseController
  def show
    @sales_order = SalesOrder.find_by(company: current_company, id: params[:id])
    if @sales_order.nil?
      redirect_to sales_orders_path
    end
  end
end
