# == Schema Information
#
# Table name: purchase_orders
#
#  id                  :integer          not null, primary key
#  company_id          :integer
#  supplier_id         :integer
#  bill_to_location_id :integer
#  ship_to_location_id :integer
#  status              :string
#  total_amount        :integer
#  due_on              :date
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  order_number        :string(64)
#  contact_email       :string(64)
#  notes               :text
#

class PurchaseOrdersController < ApplicationController
  def index
    @purchase_orders = current_company.purchase_orders.order(created_at: :desc)
  end

  def show
    @purchase_order = PurchaseOrder.find(params[:id])
  end

  def new
    @purchase_order = PurchaseOrder.new(company: current_company)
  end

  def create
    @purchase_order = current_company.purchase_orders.build(purchase_order_params)
    status = params[:active].present? ? 'active' : 'draft'
    @purchase_order.status = status
    if @purchase_order.save
      # @purchase_order.update_total_amount
      redirect_to purchase_order_path(@purchase_order)
    else
      render :new
    end
  end

  def approve
    @purchase_order = PurchaseOrder.find_by(id: params[:id], company: current_company)
    if @purchase_order
      @purchase_order.approve!
      redirect_to purchase_order_path(@purchase_order)
    else
      redirect_to purchase_orders_path
    end
  end


  private


    def purchase_order_params
      params.require(:purchase_order).permit(
        :order_number, :supplier_id, :ship_to_location_id, :bill_to_location_id, :contact_email, :due_on,
        details_attributes: [:id, :_destroy, :variant_id, :quantity, :cost_per_unit, variant_attributes: [:id]]
      )
    end
end
