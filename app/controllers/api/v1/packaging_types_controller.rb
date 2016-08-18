class Api::V1::PackagingTypesController < Api::V1::BaseController
  def index
    packaging_types = PackagingType.select(:id, :name, :company_id, :code).where("company_id IS NULL OR company_id = ?", current_company.id).order(:id)
    render json: { packaging_types: packaging_types }
  end
end
