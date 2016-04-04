# == Schema Information
#
# Table name: purchase_orders
#
#  id                  :integer          not null, primary key
#  company_id          :integer
#  supplier_id         :integer
#  bill_to_location_id :integer
#  ship_to_location_id :integer
#  status              :integer          default(0), not null
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

  end

  def new
    @purchase_order = current_company.purchase_orders.build
  end

  def create
    @purchase_order = current_company.purchase_orders.build(purchase_order_params)
    status = params[:active].present? ? 'active' : 'draft'
    @purchase_order.status = status
    if @purchase_order.save
      redirect_to purchase_order_path(@purchase_order)
    else
      render :new
    end
  end


  private


    def purchase_order_params
      params.require(:purchase_order).permit(:order_number, :supplier_id, :ship_to_location_id, :bill_to_location_id, :contact_email, :due_on)
    end
end
