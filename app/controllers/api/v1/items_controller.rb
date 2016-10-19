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
  #       bin_location_stocks: [
  #         {
  #           name: "倉庫 (預設)",
  #           expiry_date: '2016-09-30',
  #           on_hand_count: 200
  #         },
  #         {
  #           name: "倉庫 (上層)",
  #           expiry_date: '2016-09-15',
  #           on_hand_count: 300
  #         }
  #       ],
  #       on_hand_count: 500
  #     }
  #   ]
  # }
  def stock_info_by_location
    item = Item.find_by(id: params[:id])
    if item.blank?
      render json: { errors: "Item not found" }, status: :bad_request and return
    end

    location_variants = LocationVariant.includes({ bin_location: :location }, :variant).where('location_variants.quantity > 0 AND variants.item_id = ?', item.id).order("locations.id")

    stock_info_by_location = {}
    # {
    #   '1' => {
    #     location_name: 'xxx'
    #     bin_location_stocks: [
    #       { name: 'xxx', location_id: 123, expiry_date: 'xxxx-xx-xx', on_hand_count: 100 },
    #       { name: 'yyy', location_id: 456, expiry_date: 'xxxx-xx-xx', on_hand_count: 200 },
    #     ]
    #   },
    #   '2' => { ... }
    # }
    location_variants.each do |lv|
      h = {
        name: "#{lv.bin_location.location.name} (#{lv.bin_location.name})",
        expiry_date: lv.variant.expiry_date,
        on_hand_count: lv.quantity
      }
      location_id = lv.bin_location.location_id
      stock_info_by_location[location_id.to_s] ||= {}
      stock_info_by_location[location_id.to_s][:location_id] = lv.bin_location.location_id
      stock_info_by_location[location_id.to_s][:location_name] = lv.bin_location.location.name
      stock_info_by_location[location_id.to_s][:bin_location_stocks] ||= []
      stock_info_by_location[location_id.to_s][:bin_location_stocks] << h
    end

    stock_info_by_location.each do |location_id, info|
      sum = 0
      info[:bin_location_stocks].each do |stock|
        sum += stock[:on_hand_count]
      end
      info[:on_hand_count] = sum
    end

    stock_info_by_location_array = stock_info_by_location.map { |location_id, info| info }

    render json: { stock_info_by_location: stock_info_by_location_array }
  end

  private

    def item_params
      params.permit(:name, :sku, :sku_from_supplier, :sellable, :purchasable, :wholesale_price, :retail_price, :purchase_price, :description)
    end
end
