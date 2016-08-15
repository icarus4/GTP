class Api::V1::ItemsController < Api::V1::BaseController
  def index
    items = current_company.items.where(item_series_id: params[:item_series_id]).includes(:variants)
    render json: { items: items.as_json(include: :variants, except: [:created_at, :updated_at]) }
  end

  def create
    item_series = ItemSeries.find_by(company: current_company, id: params[:item_series_id])
    if item_series.blank?
      render json: { errors: "item_series not found" }, status: :bad_request and return
    end

    item = item_series.items.build(
      company:                current_company,
      name:                   params[:name].strip.presence,
      sku:                    params[:sku].strip.presence,
      purchase_price:         params[:purchase_price].strip.presence,
      wholesale_price:        params[:wholesale_price].strip.presence,
      retail_price:           params[:retail_price].strip.presence,
      cost_per_unit:          params[:cost_per_unit].strip.presence,
      on_hand_count:          params[:on_hand_count].strip.presence,
      available_count:        params[:on_hand_count].strip.presence, # Set available_count to on_hand_count at initial
      low_stock_alert_level:  params[:low_stock_alert_level].strip.presence, # Set available_count to on_hand_count at initial
    )

    if item.save
      render json: { item: item }
    else
      render json: { errors: item.errors.full_messages }, status: :bad_request
    end
  end
end
