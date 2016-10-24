class Api::V1::PurchaseOrdersController < Api::V1::BaseController
  def next_number
    render json: { next_number: PurchaseOrder.next_number(current_company.id) }
  end

  def show
    purchase_order = PurchaseOrder.includes(:partner).find_by(company: current_company, id: params[:id])
    if purchase_order.blank?
      render json: { errors: 'Purchase order not found' }, status: :bad_request and return
    end

    render json: { purchase_order: purchase_order.as_json(include: [:partner, :ship_to_location, :bill_to_location]) }
  end

  def create
    partner = Partner.find_by(company: current_company, id: params[:purchase_order][:partner_id])

    purchase_order = current_company.purchase_orders.build(purchase_order_params)
    purchase_order.partner = partner

    line_items = []
    begin
      ActiveRecord::Base.transaction do
        purchase_order.save!

        # Assign attributes to line items then save
        params[:purchase_order_line_items].each do |_, input_line_item|
          line_item = if input_line_item[:id].present?
                        Order::LineItem.find_by(id: input_line_item[:id], purchase_order: purchase_order) || Order::LineItem.new(purchase_order: purchase_order)
                      else
                        Order::LineItem.new(purchase_order: purchase_order)
                      end
          line_item.attributes = {
            item_id:    input_line_item[:item_id],
            quantity:   input_line_item[:quantity],
            unit_price: input_line_item[:unit_price],
            tax_rate:   input_line_item[:tax_rate],
          }
          line_items << line_item
        end

        # 若只有 line_items.each(&:save!) 沒有 line_items.each(&:valid?)
        # 則只有一個錯誤會在save!時顯示出來，因此為了讓所有錯誤都顯示，因而先跑一次line_items.each(&:valid?)
        line_items.each(&:valid?)
        raise ActiveRecord::RecordInvalid if line_items.any? { |li| li.errors.any? } # If any line item is not valid, raise exception for transaction rollback
        line_items.each(&:save!)

        purchase_order.calculate!
      end
    rescue
      render json: {
        purchase_order: { errors: purchase_order.errors },
        purchase_order_line_items: line_items.map { |li| { errors: li.errors } }
      }, status: :bad_request and return
    end

    render json: { purchase_order: purchase_order, purchase_order_line_items: line_items }
  end

  private

    def purchase_order_params
      params.require(:purchase_order).permit(
        :bill_to_location_id,
        :ship_to_location_id,
        :status,
        :tax_treatment,
        :email,
        :expected_delivery_date,
        :notes,
      )
    end
end
