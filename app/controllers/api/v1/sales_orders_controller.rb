class Api::V1::SalesOrdersController < Api::V1::BaseController
  def next_number
    render json: { next_number: SalesOrder.next_number(current_company.id) }
  end

  def create
    # Check the specified customer exists and is belongs to current company
    customer = current_company.customers.find_by(id: params[:customer][:id])
    render json: nil, status: :bad_request and return if customer.blank?

    # Check order number exists or not
    render json: nil, status: :bad_request and return if SalesOrder.where(order_number: params[:orderNumber]).exists?

    # TODO: check ship_to, ship_from and receipt location is valid or not

    sales_order = nil
    ActiveRecord::Base.transaction do
      sales_order = SalesOrder.create!(
        company: current_company,
        customer: customer,
        bill_to_location_id:   params[:billToLocation][:id],
        ship_to_location_id:   params[:shipToLocation][:id],
        ship_from_location_id: params[:shipFromLocation][:id],
        issued_on: Time.zone.today,
        shipped_on: params[:shippedOn],
        order_number: params[:orderNumber]
      )
      params[:items].each do |_, item_params|
        item = current_company.items.find_by(id: item_params[:itemId])
        next if item.nil?
        # TODO: 讓user可選擇已存在的任何一個variant
        variant = Variant.where(item: item).order(:expiry_date).limit(1).first
        next if variant.nil?
        raise "Invalid quantity: #{item[:quantity]}" if item_params[:quantity].blank? || item_params[:quantity]&.is_not_integer?
        note = item_params[:note].present? ? item_params[:note].strip : nil
        sales_order.details.create!(variant: variant, quantity: item_params[:quantity].to_i, unit_price: item_params[:unitPrice].to_i, note: note)
      end

      sales_order.update_total_amount!
      sales_order.update_item_available_count!
    end

    render json: { sales_order: sales_order }
  end
end
