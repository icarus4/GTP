class Api::V1::Items::BinLocationsController < Api::V1::BaseController
  # 取得某個item的所有庫存資訊
  def index
    item = Item.find_by(id: params[:item_id], company: current_company)
    if item.nil?
      render json: { errors: "Item not found" }, status: :bad_request and return
    end

    bin_locations = BinLocation.includes(:location, location_variants: :variant)
                               .where(variants: { item_id: item.id })

    render json: {
      bin_locations: bin_locations.as_json(
        include: [
          :location, {
            location_variants: { include: :variant }
          }
        ]
      )
    }
  end
end
