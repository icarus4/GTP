class Api::V1::Items::PriceListsController < Api::V1::BaseController
  # 取得所有price list，且包含指定item的price
  def index
    item = Item.find_by(id: params[:item_id], company: current_company)
    if item.nil?
      render json: { errors: "Item not found" }, status: :bad_request and return
    end

    price_lists = PriceList.includes(:item_price_lists).where(item_price_lists: { item_id: item.id })
    _price_lists = price_lists.map do |price_list|
      price_list.as_json.merge!(price: price_list.item_price_lists.first.try(:price))
    end
    render json: { price_lists: _price_lists }
  end
end
