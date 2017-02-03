class Api::V1::ItemsController < Api::V1::BaseController
  def index
    items = current_company.items
    render json: { items: items }
  end

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

  # 列出特定item的庫存資訊
  # Example return json:
  # {
  #   stock_info_by_location: [
  #     {
  #       location_id: 1,
  #       location_name: "倉庫",
  #       quantity: 500,
  #       sellable_quantity: xxx,
  #       committed_quantity: xxx,
  #       variants: [
  #         {
  #           expiry_date: '2016-09-30',
  #           quantity:    xxx,
  #           sellable_quantity: xxx,
  #           committed_quantity: xxx,
  #         },
  #         ...
  #       ],
  #     },
  #     ...
  #   ]
  # }
  def stock_info_by_location
    item = Item.find_by(id: params[:id])
    if item.blank?
      render json: { errors: "Item not found" }, status: :bad_request and return
    end

    location_variants = LocationVariant.includes(:location, :variant).where('location_variants.quantity > 0 AND variants.item_id = ?', item.id).order("locations.id")

    stock_info_by_location = {}
    # {
    #   '1' => {
    #     name: 'xxx',
    #     variants: [
    #       { expiry_date: 'xxxx-xx-xx', quantity: 100, sellable_quantity: xxx, committed_quantity: xxx },
    #       { expiry_date: 'xxxx-xx-xx', quantity: 200, sellable_quantity: xxx, committed_quantity: xxx },
    #     ]
    #   },
    #   '2' => { ... }
    # }
    location_variants.each do |lv|
      h = {
        expiry_date: lv.variant.expiry_date,
        quantity:    lv.quantity,
        sellable_quantity:  lv.sellable_quantity,
        committed_quantity: lv.committed_quantity,
      }
      location_id = lv.location_id
      stock_info_by_location[location_id] ||= {}
      stock_info_by_location[location_id][:location_id] = lv.location_id
      stock_info_by_location[location_id][:location_name] = lv.location.name
      stock_info_by_location[location_id][:variants] ||= []
      stock_info_by_location[location_id][:variants] << h
    end

    stock_info_by_location.each do |location_id, info|
      info[:quantity]           = info[:variants].reduce(0) { |sum, variant_info| sum + variant_info[:quantity] }
      info[:sellable_quantity]  = info[:variants].reduce(0) { |sum, variant_info| sum + variant_info[:sellable_quantity] }
      info[:committed_quantity] = info[:variants].reduce(0) { |sum, variant_info| sum + variant_info[:committed_quantity] }
    end

    stock_info_by_location_array = stock_info_by_location.map { |location_id, info| info }

    render json: { stock_info_by_location: stock_info_by_location_array }
  end

  private

    def item_params
      params.permit(:name, :sku, :sku_from_supplier, :sellable, :purchasable, :wholesale_price, :retail_price, :purchase_price, :description)
    end
end
