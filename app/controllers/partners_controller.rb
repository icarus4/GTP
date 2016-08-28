class PartnersController < ApplicationController
  before_action :authenticate_user!

  def index
    @partners = current_company.partners.includes(:roles).order(:id)
  end

  def new
  end

  def show
    @partner = current_company.partners.includes(:roles).find_by(id: params[:id])
    if @partner.nil?
      redirect_to partners_path
    end
  end
end
