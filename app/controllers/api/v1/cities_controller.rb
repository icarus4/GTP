class Api::V1::CitiesController < Api::V1::BaseController
  def index
    cities = City.select(:id, :name).all.order(:id)
    render json: { cities: cities }
  end
end
