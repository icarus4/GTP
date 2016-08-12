class ItemSeriesController < ApplicationController
  def index
    @item_series = current_company.item_series.order(id: :desc)
  end

  def show
    @item_series = ItemSeries.find_by(company: current_company, id: params[:id])
    redirect_to item_series_index_path unless @item_series
  end

  def new
  end
end
