class Api::V1::SalesOrdersController < Api::V1::BaseController
  def next_number
    render json: { next_number: SalesOrder.next_number(current_company.id) }
  end

  def show
    sales_order = SalesOrder.find_by(company: current_company, id: params[:id])
    render json: { errors: "Sales order not found" }, status: :not_found and return if sales_order.nil?

    render json: { sales_order: sales_order.as_json(include: [:partner, :ship_to_location, :ship_from_location, :bill_to_location]) }
  end

  def create
    partner = Partner.select(:id).find_by(company: current_company, id: params[:sales_order][:partner_id])
    render json: { errors: 'Partner not found' }, status: :bad_request and return if partner.nil?

    ship_from_location = Location.select(:id).find_by(locationable: current_company, id: params[:sales_order][:ship_from_location_id])
    render json: { errors: 'Ship from location not found' }, status: :bad_request and return if ship_from_location.nil?

    sales_order                    = current_company.sales_orders.build(sales_order_params)
    sales_order.partner            = partner
    sales_order.ship_from_location = ship_from_location

    ActiveRecord::Base.transaction do
      sales_order.save!

      params[:sales_order_line_items].each do |_, input_line_item|
        item = Item.select(:id).find_by(company: current_company, id: input_line_item[:item_id])
        next if item.nil?

        line_item = SalesOrder::LineItem.create!(
          sales_order: sales_order,
          item_id:     input_line_item[:item_id],
          quantity:    input_line_item[:quantity],
          unit_price:  input_line_item[:unit_price],
          tax_rate:    input_line_item[:tax_rate],
        )

        # 從庫存中尋找適當的貨品保留作為出貨用
        # 找到的 location_variant 的數量不一定足夠，因此用迴圈逐一找尋，直到總數量符合出貨量
        remaining_quantity = line_item.quantity
        offset = 0
        loop do
          # 找出最快過期的出貨
          chosen_lv = LocationVariant.where(company: current_company, location: ship_from_location, item: item)
                                     .default_sales_committed_sequence
                                     .offset(offset).first
          break if chosen_lv.nil?
          committed_quantity = chosen_lv.sellable_quantity >= remaining_quantity ? remaining_quantity : chosen_lv.sellable_quantity
          commitment = SalesOrder::LineItemCommitment.create!(
            line_item:        line_item,
            location_variant: chosen_lv,
            quantity:         committed_quantity
          )
          remaining_quantity -= committed_quantity
          if remaining_quantity == 0
            break
          elsif remaining_quantity < 0
            raise "Should not be here"
          end
          offset += 1
        end
      end

      sales_order.calculate!
    end

    render json: { sales_order: sales_order, sales_order_line_items: sales_order.line_items }
  end

  def finalize
    sales_order = SalesOrder.find_by(company: current_company, id: params[:id])
    render json: { errors: 'Sales order not found' }, status: :bad_request and return if sales_order.nil?

    sales_order.finalized!
    render json: { sales_order: sales_order }
  end

  private

    def sales_order_params
      params.require(:sales_order).permit(
        :bill_to_location_id,
        :ship_to_location_id,
        :assignee_id,
        :status,
        :tax_treatment,
        :issued_on,
        :expected_delivery_date,
        :email,
        :phone,
        :notes
      )
    end
end
