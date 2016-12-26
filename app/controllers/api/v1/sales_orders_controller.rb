class Api::V1::SalesOrdersController < Api::V1::BaseController
  def next_number
    render json: { next_number: SalesOrder.next_number(current_company.id) }
  end

  def create
    partner = Partner.find_by(company: current_company, id: params[:sales_order][:partner_id])
    render json: { errors: 'Partner not found' }, status: :bad_request and return if partner.nil?

    sales_order = current_company.sales_orders.build(sales_order_params)
    sales_order.partner = partner

    line_items = []
    ActiveRecord::Base.transaction do
      sales_order.save!

      params[:sales_order_line_items].each do |_, input_line_item|
        item = Item.find_by(company: current_company, id: input_line_item[:item_id])
        next if item.nil?

        # TODO: 讓user可選擇已存在的任何一個variant

        # 找尋
        # 優先從有 expiry_date 的 variant 選取
        variant = Variant.where(item: item).where.not(expiry_date: nil).order(:expiry_date).first || Variant.where(item: item).where(expiry_date: nil).order(:created_at).first
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

  private

    def sales_order_params
      params.require(:sales_order).permit(
        :bill_to_location_id,
        :ship_to_location_id,
        :ship_from_location_id,
        :assignee_id,
        :status,
        :tax_treatment,
        :issued_on,
        :expected_delivery_date,
        :email,
        :notes
      )
    end
end
