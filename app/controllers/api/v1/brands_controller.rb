class Api::V1::BrandsController < Api::V1::BaseController
  def index
    render json: { brands: current_company.brands.order(:id) }
  end

  def create
    brand = current_company.brands.build(name: params[:brand][:name].strip)
    if brand.save
      render json: { brand: brand }
    else
      render json: { errors: brand.errors }, status: :bad_request
    end
  end
end
