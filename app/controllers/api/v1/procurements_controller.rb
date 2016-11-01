class Api::V1::ProcurementsController < Api::V1::BaseController
  def create
    p = params.require(:procurement)
    purchase_order = PurchaseOrder.find_by(company: current_company, id: p[:purchase_order_id])

    if purchase_order.nil?
      render json: { errors: 'Purchase order not found' }, status: :not_found and return
    end

    ActiveRecord::Base.transaction do
      # Don't create procurement if there is no purchase_order_line_items
      if p[:purchase_order_line_items].to_unsafe_h.size > 0
        procurement = Procurement.create!(purchase_order: purchase_order, procured_at: p[:procured_on])
      end

      p[:purchase_order_line_items].each do |_, input_line_item|
        line_item = Order::LineItem.find_by(id: input_line_item[:id], order_id: purchase_order.id)
        next if line_item.nil?
        quantity_to_procure = input_line_item[:quantity_to_procure]&.to_i
        next if quantity_to_procure.nil?

        # 若原先line_item.quantity為10個，此次收取3個
        # 則另外產生一個新的line_item，quantity為3，並將原先的line_item.quantity變為7
        if line_item.quantity > quantity_to_procure
          Order::LineItem.create!(
            order_id:    purchase_order.id,
            procurement: procurement,
            item_id:     line_item.item_id,
            variant_id:  line_item.variant_id,
            quantity:    line_item.quantity - quantity_to_procure,
            unit_price:  line_item.unit_price,
            tax_rate:    line_item.tax_rate,
          )
          line_item.update!(quantity: line_item.quantity - quantity_to_procure)
        else
          line_item.procurement = procurement
          line_item.save!
        end
      end

      # Change status to received when all line_items are procured
      purchase_order.received! if purchase_order.all_line_items_are_procured?
    end
  end

end
