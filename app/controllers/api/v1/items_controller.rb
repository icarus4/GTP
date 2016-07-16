class Api::V1::ItemsController < Api::V1::BaseController
  def index
    items = current_company.items.includes(:variants).joins(:variants)
    render json: { items: items.as_json(include: :variants, except: [:created_at, :updated_at]) }
  end
end
