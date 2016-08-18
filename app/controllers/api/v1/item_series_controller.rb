class Api::V1::ItemSeriesController < Api::V1::BaseController
  def create
    item_series = current_company.item_series.build(item_series_params)
    if item_series.save
      render json: item_series
    else
      render json: { errors: item_series.errors.full_messages }, status: :bad_request
    end
  end

  private

    def item_series_params
      params.require(:item_series).permit(
        :brand_id,
        :name,
        :manufacturer_id,
        :storage_and_transport_condition,
        :storage_and_transport_condition_note,
        :raw_material,
        :main_and_auxiliary_material,
        :food_additives,
        :warnings
      )
    end
end
