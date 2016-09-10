class Api::V1::ItemSeries::ItemsController < Api::V1::BaseController
  def index
    items = current_company.items.includes_for_api.where(item_series_id: params[:item_series_id]).order(:id)
    render json: { items: items.as_json(include: [:variants, :packaging_type], except: [:created_at, :updated_at]) }
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
      purchase_price:         params[:purchase_price]&.to_d,
      wholesale_price:        params[:wholesale_price]&.to_d,
      retail_price:           params[:retail_price]&.to_d,
      cost_per_unit:          params[:cost_per_unit]&.to_d,
      packaging_type_id:      params[:packaging_type_id],
      weight_unit:            params[:weight_unit],
      weight_value:           params[:weight_value]&.to_d,
      low_stock_alert_level:  params[:low_stock_alert_level]&.to_i, # Set available_count to on_hand_count at initial
    )

    error_message = nil
    begin
      ActiveRecord::Base.transaction do
        item.save!

        params[:price_lists].each do |_, price_list|
          pl = PriceList.find_by(company: current_company, id: price_list[:id])
          next if pl.nil?

          ipl = ItemPriceList.find_or_initialize_by(price_list: pl, item: item)
          ipl.price = price_list[:price]&.to_d
          ipl.save!
        end

        params[:item_details].each do |_, item_detail|
          next if item_detail[:on_hand_count].blank? || item_detail[:bin_location_id].blank?
          variant = Variant.find_or_create_by!(
            item: item,
            expiry_date:                   item_detail[:expiry_date],
            import_admitted_notice_number: item_detail[:import_admitted_notice_number],
            goods_declaration_number:      item_detail[:goods_declaration_number],
            item_number:                   item_detail[:item_number],
            lot_number:                    item_detail[:lot_number]
          )
          variant.save!

          lv = LocationVariant.find_or_initialize_by(
            company:         current_company,
            variant:         variant,
            bin_location_id: item_detail[:bin_location_id],
            quantity:        item_detail[:on_hand_count],
          )
          lv.save!
        end
        item.update_available_count!
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
