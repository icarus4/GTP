class Api::V1::ItemSeries::ItemsController < Api::V1::BaseController
  def index
    items = current_company.items.includes_for_api.where(item_series_id: params[:item_series_id]).order(:id)
    render json: { items: items.as_json(include: [:variants, :packaging_type, :packs, item_price_lists: { methods: [:name, :price_list_type_in_chinese] }], except: [:created_at, :updated_at]) }
  end

  def create
    item_series = ::ItemSeries.find_by(company: current_company, id: params[:item_series_id])
    if item_series.blank?
      render json: { errors: "item_series not found" }, status: :bad_request and return
    end

    item = item_series.items.build(
      company:                current_company,
      name:                   params[:name],
      sku:                    params[:sku],
      purchase_price:         params[:purchase_price],
      wholesale_price:        params[:wholesale_price],
      retail_price:           params[:retail_price],
      cost_per_unit:          params[:cost_per_unit],
      packaging_type_id:      params[:packaging_type_id],
      weight_unit:            params[:weight_unit],
      weight_value:           params[:weight_value],
      low_stock_alert_level:  params[:low_stock_alert_level], # Set sellable_quantity to quantity at initial
    )

    error_message = nil
    begin
      ActiveRecord::Base.transaction do
        item.save!

        # Create price lists
        params[:price_lists]&.each do |_, price_list|
          next if price_list[:price].blank?
          pl = PriceList.find_by(company: current_company, id: price_list[:id])
          next if pl.nil?

          ipl = ItemPriceList.find_or_initialize_by(price_list: pl, item: item)
          ipl.price = price_list[:price].to_d
          ipl.save!
        end

        # Create item initial stocks
        params[:item_details]&.each do |_, item_detail|
          next if item_detail[:quantity].blank? || item_detail[:location_id].blank?

          variant = Variant.find_or_create_by!(
            item: item,
            expiry_date:                   item_detail[:expiry_date].presence, # If expiry_date is not specified, convert empty string to nil
            import_admitted_notice_number: item_detail[:import_admitted_notice_number],
            goods_declaration_number:      item_detail[:goods_declaration_number],
            item_number:                   item_detail[:item_number],
            lot_number:                    item_detail[:lot_number]
          )

          lv = LocationVariant.find_or_initialize_by(
            company:     current_company,
            variant:     variant,
            location_id: item_detail[:location_id],
            quantity:    item_detail[:quantity],
          )
          lv.save!
        end

        # Create packs
        params[:packs]&.each do |_, input_pack|
          pack = item.packs.build
          pack.name = input_pack[:name]
          pack.size = input_pack[:size].to_i
          pack.save!
        end
      end
    rescue => e
      error_message = e.to_s
    end

    if error_message.nil?
      render json: { item: item.as_json(include: [:variants, :packaging_type]) }
    else
      render json: { errors: error_message }, status: :bad_request
    end
  end
end
