class Api::V1::Locations::ItemsController < Api::V1::BaseController
  # 顯示某個商品在某個地點的庫存量
  # Format:
  # "item": {
  #   "id": 1,
  #   "name": "罐裝",
  #   "location": {
  #     "id": 2,
  #     "name": "倉庫1",
  #     "on_hand_count": 100
  #   }
  # }
  def show
    location = Location.select(:id, :name).find_by(locationable: current_company, id: params[:location_id])
    render json: { errors: 'Location not found' }, status: :bad_request and return if location.nil?

    item = Item.select(:id, :name).find_by(company: current_company, id: params[:id])
    render json: { errors: 'Item not found' }, status: :bad_request and return if location.nil?

    on_hand_count = LocationVariant
                     .joins(:variant, :bin_location)
                     .where("variants.item_id = ? AND bin_locations.location_id = ?", item.id, location.id)
                     .sum(:quantity)


    render json: { item: item.as_json.merge(
      location: { id: location.id, name: location.name, on_hand_count: on_hand_count }
    )}
  end
end
