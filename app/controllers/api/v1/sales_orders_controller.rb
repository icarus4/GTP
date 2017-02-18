class Api::V1::SalesOrdersController < Api::V1::BaseController
  def next_number
    render json: { next_number: SalesOrder.next_number(current_company.id) }
  end

  def show
    sales_order = SalesOrder.find_by(company: current_company, id: params[:id])
    render json: { errors: "Sales order not found" }, status: :not_found and return if sales_order.nil?

    render json: { sales_order: sales_order.as_json(include: [:partner, :ship_to_location, :ship_from_location, :bill_to_location, :assignee]) }
  end

  def create
    partner = Partner.select(:id).find_by(company: current_company, id: params[:sales_order][:partner_id])
    render json: { errors: 'Partner not found' }, status: :bad_request and return if partner.nil?

    ship_from_location = Location.select(:id).find_by(locationable: current_company, id: params[:sales_order][:ship_from_location_id])
    render json: { errors: 'Ship from location not found' }, status: :bad_request and return if ship_from_location.nil?

    sales_order                    = current_company.sales_orders.build(sales_order_params)
    sales_order.partner            = partner
    sales_order.ship_from_location = ship_from_location
    sales_order.status             = 'draft' # Status always start from 'draft'. Change status by methods defined in state machine of sales order

    begin
      ActiveRecord::Base.transaction do
        sales_order.save!

        params[:sales_order_line_items].each do |_, input_line_item|
          item = Item.select(:id).find_by(company: current_company, id: input_line_item[:item_id])
          next if item.nil?

          line_item = SalesOrder::LineItem.create!(
            sales_order: sales_order,
            item_id:     item.id,
            quantity:    input_line_item[:quantity],
            unit_price:  input_line_item[:unit_price],
            tax_rate:    input_line_item[:tax_rate],
          )
        end

        sales_order.approve! if params[:sales_order][:status] == 'active'
      end
    rescue => e
      render json: { errors: e.message }, status: :bad_request and return
    end

    render json: { sales_order: sales_order, sales_order_line_items: sales_order.line_items }
  end

  def update
    ship_from_location = Location.select(:id).find_by(locationable: current_company, id: params[:sales_order][:ship_from_location_id])
    render json: { errors: 'Ship from location not found' }, status: :bad_request and return if ship_from_location.nil?

    sales_order = SalesOrder.find_by(company: current_company, id: params[:sales_order][:id])
    render json: { errors: 'Sales order not found' }, status: :not_found and return if sales_order.nil?
    render json: { errors: 'This sales order is not editable' }, status: :bad_request and return unless sales_order.editable?

    sales_order.attributes = sales_order_params
    sales_order.ship_from_location = ship_from_location

    # 用來與更新 line item 後的所有 line item 做比對，找出被刪除的 line item
    line_item_ids_before = sales_order.line_items.pluck(:id)
    line_item_ids_after  = []

    begin
      ActiveRecord::Base.transaction do
        sales_order.save!

        # params[:sales_order_line_items]&.each 使用 "&".each 是因為若 user 將 line item 刪光光，則 params[:sales_order_line_items] 會是 nil
        params[:sales_order_line_items]&.each do |_, input_line_item|
          if input_line_item[:id].present?
            line_item = SalesOrder::LineItem.find_by(id: input_line_item[:id], sales_order_id: sales_order.id)
            next if line_item.nil?

            line_item.attributes = {
              item_id:     input_line_item[:item_id],
              quantity:    input_line_item[:quantity],
              unit_price:  input_line_item[:unit_price],
              tax_rate:    input_line_item[:tax_rate],
            }

            # item_id 或 quantity 變動會影響 committed line item，故重新建立 line_item
            if line_item.item_id_changed? || line_item.quantity_changed?
              created_at = line_item.created_at
              line_item.destroy!
              line_item = SalesOrder::LineItem.create!(
                sales_order: sales_order,
                item_id:     input_line_item[:item_id],
                quantity:    input_line_item[:quantity],
                unit_price:  input_line_item[:unit_price],
                tax_rate:    input_line_item[:tax_rate],
                created_at:  created_at, # Use original line item's created_at for keeping the sequence of line items
              )
              line_item_ids_after << line_item.id
            else
              # unit_price 與 tax_rate 的變動與 committed line item 無關，可以直接修改
              line_item.save!
              line_item_ids_after << line_item.id
            end
          else
            item = Item.select(:id).find_by(company: current_company, id: input_line_item[:item_id])
            next if item.nil?

            line_item = SalesOrder::LineItem.create!(
              sales_order: sales_order,
              item_id:     item.id,
              quantity:    input_line_item[:quantity],
              unit_price:  input_line_item[:unit_price],
              tax_rate:    input_line_item[:tax_rate],
            )
          end
        end # End of params[:sales_order_line_items].each do |_, input_line_item|

        # Destroy line_items not in params[:sales_order_line_items]
        # Those line_items are removed from edit sales order page by user
        (line_item_ids_before - line_item_ids_after).each do |line_item_id|
          SalesOrder::LineItem.find_by(id: line_item_id)&.destroy!
        end

        sales_order.commit_stocks! if sales_order.active?
      end # End of transaction
    rescue => e
      render json: { errors: e.message }, status: :bad_request and return
    end

    render json: { sales_order: sales_order }
  end

  def approve
    sales_order = SalesOrder.find_by(company: current_company, id: params[:id])
    render json: { errors: 'Sales order not found' }, status: :bad_request and return if sales_order.nil?

    sales_order.approve!
    render json: { sales_order: sales_order }
  end

  def finalize
    sales_order = SalesOrder.find_by(company: current_company, id: params[:id])
    render json: { errors: 'Sales order not found' }, status: :bad_request and return if sales_order.nil?

    sales_order.finalize!
    render json: { sales_order: sales_order }
  end

  def destroy
    sales_order = SalesOrder.find_by(company: current_company, id: params[:id])
    render json: { errors: 'Sales order not found' }, status: :bad_request and return if sales_order.nil?

    sales_order.delete!
    render json: { sales_order: sales_order }
  end

  def void
    sales_order = SalesOrder.find_by(company: current_company, id: params[:id])
    render json: { errors: 'Sales order not found' }, status: :bad_request and return if sales_order.nil?

    sales_order.void!
    render json: { sales_order: sales_order }
  end

  def delete_shipments
    sales_order = SalesOrder.find_by(company: current_company, id: params[:id])
    render json: { errors: 'Sales order not found' }, status: :bad_request and return if sales_order.nil?

    begin
      ActiveRecord::Base.transaction do
        sales_order.shipments.destroy_all
      end
    rescue => e
      render json: { errors: e.message }, status: :bad_request and return
    end

    render json: { sales_order: sales_order }
  end

  private

    def sales_order_params
      params.require(:sales_order).permit(
        :bill_to_location_id,
        :ship_to_location_id,
        :assignee_id,
        :tax_treatment,
        :issued_on,
        :expected_delivery_date,
        :email,
        :phone,
        :notes
      )
    end
end
