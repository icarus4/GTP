class Api::V1::Locations::ItemsController < Api::V1::BaseController
  # 顯示某個商品在某個地點的庫存量
  # Format:
  # "item": {
  #   "id": 1,
  #   "name": "罐裝",
  #   "location": {
  #     "id": 2,
  #     "name": "倉庫1",
  #     "quantity": 150,
  #     "sellable_quantity": 100
  #     "committed_quantity": 100
  #   }
  # }
  def show
    location = Location.select(:id, :name).find_by(locationable: current_company, id: params[:location_id])
    render json: { errors: 'Location not found' }, status: :bad_request and return if location.nil?

    item = Item.select(:id, :name).find_by(company: current_company, id: params[:id])
    render json: { errors: 'Item not found' }, status: :bad_request and return if location.nil?

    quantity = LocationVariant
                 .joins(:variant)
                 .where("variants.item_id = ? AND location_id = ?", item.id, location.id)
                 .sum(:quantity)

    sellable_quantity = LocationVariant
                          .joins(:variant)
                          .where("variants.item_id = ? AND location_id = ?", item.id, location.id)
                          .sum(:sellable_quantity)

    committed_quantity = LocationVariant
                           .joins(:variant)
                           .where("variants.item_id = ? AND location_id = ?", item.id, location.id)
                           .sum(:committed_quantity)


    render json: {
      item: item.as_json.merge(
        location: { id: location.id, name: location.name, quantity: quantity, sellable_quantity: sellable_quantity, committed_quantity: committed_quantity }
      )
    }
  end
end
