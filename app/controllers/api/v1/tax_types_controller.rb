class Api::V1::TaxTypesController < Api::V1::BaseController
  def index
    tax_types = current_company.tax_types.select(:id, :name, :percentage).order(:id)
    @tax_types = tax_types.map do |tt|
      {
        id:      tt.id,
        name:    tt.name,
        percentage: tt.percentage == tt.percentage.round ? tt.percentage.to_i : tt.percentage,
        default: tt.default?(current_company)
      }
    end
    render json: { tax_types: @tax_types }
  end

  def update
    tax_type = TaxType.find_by(company: current_company, id: params[:id])
    if tax_type.blank?
      render json: { errors: 'Tax type not found' }, status: :bad_request
    end

    tax_type.name = params[:name]
    tax_type.percentage = params[:percentage]&.to_d
    if tax_type.save
      current_company.update(default_tax_type_id: tax_type.id) if params[:default].to_bool
      render json: { tax_type: tax_type }
    else
      render json: { errors: tax_type.errors }, status: :bad_request
    end
  end

  def create
    tax_type = TaxType.new
    tax_type.company = current_company

    tax_type.name = params[:name]
    tax_type.percentage = params[:percentage]&.to_d
    if tax_type.save
      current_company.update(default_tax_type_id: tax_type.id) if params[:default].to_bool
      render json: { tax_type: tax_type }
    else
      render json: { errors: tax_type.errors }, status: :bad_request
    end
  end
end
