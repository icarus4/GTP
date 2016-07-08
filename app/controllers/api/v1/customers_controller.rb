class Api::V1::CustomersController < Api::V1::BaseController
  def index
    render json: { customers: current_company.customers }
  end

  # Get all locations of the specified customer
  def locations
    customer = Customer.find_by(id: params[:id], company: current_company)
    locations = customer.locations
    render json: { locations: locations }
  end
end
