class Api::V1::BrandsController < Api::V1::BaseController
  def index
    render json: { brands: current_company.brands }
  end
end
