class Api::V1::PurchaseOrders::ProcurementsController < Api::V1::BaseController
  def index
    purchase_order = PurchaseOrder.includes(procurements: { purchase_order_line_items: [:item, :variant] }).find_by(company: current_company, id: params[:purchase_order_id])
    if purchase_order.nil?
      render json: { errors: 'Purchase order not found' }, status: :bad_request
    end

    render json: { procurements: purchase_order.procurements.order(:procured_at, :id).as_json(include: { purchase_order_line_items: { include: [:item, :variant] } }) }
  end

  def create
    p = params.require(:procurement)
    purchase_order = PurchaseOrder.find_by(company: current_company, id: p[:purchase_order_id])

    if purchase_order.nil?
      render json: { errors: 'Purchase order not found' }, status: :not_found and return
    end

    procurement = nil
    ActiveRecord::Base.transaction do
      # Don't create procurement if there is no purchase_order_line_items
      if p[:purchase_order_line_items].to_unsafe_h.size > 0
        procurement = Procurement.create!(purchase_order: purchase_order, procured_at: p[:procured_on])
      end

      # For each line item. Do the following steps:
      # 1. Set procurement to the corresponding line_item.
      #    If the quantity to procure is not equal to the quantity of the line item, split the line item
      # 2. Create variant if necessary
      # 3. Setup LocationVariant
      p[:purchase_order_line_items].each do |_, input_line_item|
        line_item = Order::LineItem.find_by(id: input_line_item[:id], order_id: purchase_order.id)
        next if line_item.nil?
        quantity_to_procure = input_line_item[:quantity_to_procure]&.to_i
        next if quantity_to_procure.nil?
        bin_location = BinLocation.find_by(id: input_line_item[:bin_location_id])
        next if bin_location.nil?

        # 1. Set procurement to the corresponding line_item.
        #
        # 若原先line_item.quantity為10個，此次收取3個
        # 則另外產生一個新的line_item，quantity為3，並將原先的line_item.quantity變為7
        if line_item.quantity > quantity_to_procure
          procured_line_item = Order::LineItem.create!(
            order_id:    purchase_order.id,
            procurement: procurement,
            item_id:     line_item.item_id,
            variant_id:  line_item.variant_id,
            quantity:    quantity_to_procure,
            unit_price:  line_item.unit_price,
            tax_rate:    line_item.tax_rate,
          )
          line_item.update!(quantity: line_item.quantity - quantity_to_procure)
        else
          line_item.procurement = procurement
          line_item.save!
          procured_line_item = line_item
        end

        # 2. Create variant if necessary
        variant = Variant.find_or_initialize_by(
          procurement: procurement,
          item_id:     line_item.item_id,
          expiry_date:                   input_line_item[:expiry_date],
          import_admitted_notice_number: input_line_item[:import_admitted_notice_number],
          goods_declaration_number:      input_line_item[:goods_declaration_number],
          item_number:                   input_line_item[:item_number],
          lot_number:                    input_line_item[:lot_number],
        )
        variant.increment(:quantity, quantity_to_procure)
        variant.save!
        procured_line_item.update!(variant: variant)

        # 3. Setup LocationVariant
        lv = LocationVariant.find_or_initialize_by(company: current_company, bin_location: bin_location, variant: variant)
        lv.increment(:quantity, quantity_to_procure)
        lv.save!
      end

      # Change status to received when all line_items are procured
      purchase_order.received! if purchase_order.all_line_items_are_procured?
    end

    # FIXME:
    # 部分情況會導致 procurement 產生，但是卻沒有任何 variant 產生，此時的 procurement 為無效，不應該被產生
    # 目前先用此笨方法 workaround
    # 已知情況1: 使用者收貨時沒有選擇 bin_location
    procurement.destroy unless procurement.variants.exists?

    render json: { procurement: procurement }
  end
end