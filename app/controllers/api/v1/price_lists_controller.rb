class Api::V1::PriceListsController < Api::V1::BaseController
  def index
    price_lists = current_company.price_lists.order(:id)
    @price_lists = price_lists.map do |pl|
      {
        id:   pl.id,
        name: pl.name,
        price_list_type: pl.price_list_type,
        price_list_type_in_chinese: pl.price_list_type_in_chinese,
      }
    end

    render json: { price_lists: @price_lists }
  end

  def update
    price_list = PriceList.find_by(company: current_company, id: params[:id])
    if price_list.blank?
      render json: { errors: 'Price list not found' }, status: :bad_request
    end

    if price_list.update(price_list_params)
      render json: { price_list: price_list }
    else
      render json: { errors: price_list.errors.full_messages }, status: :bad_request
    end
  end

  def create
    price_list = PriceList.new(price_list_params)
    price_list.company = current_company

    if price_list.save
      render json: { price_list: price_list }
    else
      render json: { errors: price_list.errors.full_messages }, status: :bad_request
    end
  end

  private

    def price_list_params
      params.permit(:name, :price_list_type)
    end
end
