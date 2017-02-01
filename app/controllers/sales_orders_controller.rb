# == Schema Information
#
# Table name: sales_orders
#
#  id                    :integer          not null, primary key
#  company_id            :integer
#  customer_id           :integer
#  bill_to_location_id   :integer
#  ship_to_location_id   :integer
#  ship_from_location_id :integer
#  assignee_id           :integer
#  status                :string
#  total_amount          :integer
#  issued_on             :date
#  shipped_on            :date
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  order_number          :string(64)
#  contact_email         :string(64)
#  notes                 :text
#

class SalesOrdersController < ApplicationController
  def index
    @sales_orders = current_company.sales_orders.order(created_at: :desc)
  end

  def show
    @sales_order = SalesOrder.find_by(id: params[:id], company: current_company)
    if @sales_order.nil?
      redirect_to sales_orders_path
    end
  end

  def new
  end

  def edit
    @sales_order = SalesOrder.find_by(id: params[:id], company: current_company)

    if !@sales_order.editable?
      redirect_to sales_order_path(@sales_order)
    end

    if @sales_order.nil?
      redirect_to sales_orders_path
    end
  end

  def create
    @sales_order = current_company.sales_orders.build(sales_order_params)
    status = params[:active].present? ? 'active' : 'draft'
    @sales_order.status = status
    if @sales_order.save
      redirect_to sales_order_path(@sales_order)
    else
      render :new
    end
  end

  def ship
    sales_order = SalesOrder.find_by(id: params[:id], company: current_company)

    if sales_order
      sales_order.ship!
      redirect_to sales_order_path(sales_order)
    else
      redirect_to sales_orders_path
    end
  end

  private

    def sales_order_params
      params.require(:sales_order).permit(
        :order_number, :customer_id, :ship_to_location_id, :bill_to_location_id, :ship_from_location_id, :contact_email, :issued_on, :shipped_on,
        details_attributes: [:id, :_destroy, :variant_id, :quantity, :unit_price, variant_attributes: [:id]]
      )
    end
end
