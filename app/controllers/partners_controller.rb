class PartnersController < ApplicationController
  before_action :authenticate_user!

  def index
    @partners = current_company.partners.includes(:roles).order(:id)
  end

  def new
  end
end
