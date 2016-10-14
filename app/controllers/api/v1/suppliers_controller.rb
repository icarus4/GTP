class Api::V1::SuppliersController < Api::V1::BaseController
  def index
    suppliers = current_company.suppliers.order(:id)
    render json: { suppliers: suppliers }
  end
end
