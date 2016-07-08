class Api::V1::ItemsController < Api::V1::BaseController
  def index
    render json: { items: current_company.items }
  end
end
