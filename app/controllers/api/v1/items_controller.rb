class Api::V1::ItemsController < Api::V1::BaseController
  def index
    items = current_company.items.includes_for_api.where(item_series_id: params[:item_series_id])
    render json: { items: items.as_json(include: [:variants, :packaging_type], except: [:created_at, :updated_at]) }
  end

  def create
    item_series = ItemSeries.find_by(company: current_company, id: params[:item_series_id])
    if item_series.blank?
      render json: { errors: "item_series not found" }, status: :bad_request and return
    end

    item = item_series.items.build(
      company:                current_company,
      name:                   params[:name]&.strip.presence,
      sku:                    params[:sku]&.strip.presence,
      purchase_price:         params[:purchase_price]&.strip.presence,
      wholesale_price:        params[:wholesale_price]&.strip.presence,
      retail_price:           params[:retail_price]&.strip.presence,
      cost_per_unit:          params[:cost_per_unit]&.strip.presence,
      packaging_type_id:      params[:packaging_type_id]&.strip.presence,
      weight_unit:            params[:weight_unit]&.strip.presence,
      weight_value:           params[:weight_value]&.strip.presence,
      low_stock_alert_level:  params[:low_stock_alert_level]&.strip.presence, # Set available_count to on_hand_count at initial
    )

    error_message = nil
    begin
      ActiveRecord::Base.transaction do
        item.save!
        params[:item_details].each do |_, item_detail|
          variant = Variant.find_or_initialize_by(
            item: item,
            expiry_date:                   item_detail[:expiry_date],
            import_admitted_notice_number: item_detail[:import_admitted_notice_number]&.strip.presence,
            goods_declaration_number:      item_detail[:goods_declaration_number]&.strip.presence,
          )
          variant.item_number = item_detail[:item_number]&.strip.presence
          variant.lot_number  = item_detail[:log_number]&.strip.presence
          variant.save!

          lv = LocationVariant.find_or_initialize_by(
            company:         current_company,
            variant:         variant,
            bin_location_id: item_detail[:bin_location_id],
            quantity:        item_detail[:on_hand_count],
          )
          lv.save!
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
