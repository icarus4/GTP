class Api::V1::ItemsController < Api::V1::BaseController
  def update
    item = Item.includes_for_api.find_by(id: params[:id])
    if item.blank?
      render json: { errors: "Item not found" }, status: :bad_request and return
    end

    if item.update(item_params)
      params[:price_lists]&.each do |_, price_list|
        next if price_list[:price].blank?
        pl = PriceList.find_by(company: current_company, id: price_list[:id])
        next if pl.nil?

        ipl = ItemPriceList.find_or_initialize_by(price_list: pl, item: item)
        ipl.price = price_list[:price]
        ipl.save!
      end

      render json: { item: item.as_json(include: [:variants, :packaging_type, :packs, item_price_lists: { methods: [:name, :price_list_type_in_chinese] }], except: [:created_at, :updated_at]) }
    else
      render json: { errors: item.errors }, status: :bad_request
    end
  end

  private

    def item_params
      params.permit(:name, :sku, :sku_from_supplier, :sellable, :purchasable, :wholesale_price, :retail_price, :purchase_price, :description)
    end
end
