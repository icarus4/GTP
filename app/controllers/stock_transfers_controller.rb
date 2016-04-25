# == Schema Information
#
# Table name: stock_transfers
#
#  id                      :integer          not null, primary key
#  company_id              :integer
#  source_location_id      :integer
#  destination_location_id :integer
#  status                  :string(32)       not null
#  order_number            :string(64)
#  expected_transfer_date  :date
#  transferred_at          :datetime
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class StockTransfersController < ApplicationController
  def index
    @stock_transfers = current_company.stock_transfers
  end

  def new
    @stock_transfer = current_company.stock_transfers.build
  end

  def create
    @stock_transfer = current_company.stock_transfers.build(stock_transfer_params)
    if @stock_transfer.save
      redirect_to stock_transfer_path(@stock_transfer)
    else
      render :new
    end
  end

  def show
    @stock_transfer = StockTransfer.find_by(company: current_company, id: params[:id])
  end


  private


    def stock_transfer_params
      params.require(:stock_transfer).permit(
        :source_location_id, :destination_location_id, :order_number, :expected_transfer_date,
        details_attributes: [:id, :_destroy, :variant_id, :quantity, variant_attributes: [:id]]
      )
    end
end
