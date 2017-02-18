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
            item_id:     input_line_item[:item_id],
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
    render json: { errors: "Sales order not found" }, status: :not_found and return if sales_order.nil?

    sales_order.attributes = sales_order_params
    sales_order.ship_from_location = ship_from_location
    if sales_order.save
      render json: { sales_order: sales_order }
    else
      render json: { sales_order: sales_order }, status: :bad_request
    end
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
