class Api::V1::ItemsController < Api::V1::BaseController
  def index
    items = current_company.items.includes(:variants).joins(:variants)
    render json: { items: items.as_json(include: :variants, except: [:created_at, :updated_at]) }
  end

  def create
    storage_and_transport_condition_note = params[:item_series][:storage_and_transport_condition_note].present? ? params[:item_series][:storage_and_transport_condition_note].strip : nil
    series = current_company.item_series.build(
      brand_id:                             params[:item_series][:brand_id],
      manufacturer_id:                      params[:item_series][:manufacturer_id],
      storage_and_transport_condition:      params[:item_series][:storage_and_transport_condition_id].to_i,
      storage_and_transport_condition_note: storage_and_transport_condition_note,
    )

    ActiveRecord::Base.transaction do
      if series.save
        item = series.items.build(
          company_id:            current_company.id,
          name:                  params[:item][:name],
          description:           params[:item][:description],
          on_hand_count:         params[:item][:on_hand_count],
          cost_per_unit:         params[:item][:cost_per_unit],
          purchase_price:        params[:item][:purchase_price],
          wholesale_price:       params[:item][:wholesale_price],
          retail_price:          params[:item][:retail_price],
          low_stock_alert_level: params[:item][:low_stock_alert_level],
          sku:                   params[:item][:sku],
        )
        if item.save
          render json: { item: params[:item], item_series: params[:item_series] }
        else
          render json: { errors: item.errors.full_messages }, status: :bad_request
        end
      else
        render json: { errors: item.errors.full_messages }, status: :bad_request
      end
    end # ActiveRecord::Base.transaction do
  end # def create
end
