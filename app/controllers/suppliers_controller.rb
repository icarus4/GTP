# == Schema Information
#
# Table name: companies
#
#  id          :integer          not null, primary key
#  company_id  :integer
#  assignee_id :integer
#  status      :integer          default(0), not null
#  type        :string           default(""), not null
#  name        :string
#  email       :string
#  vat_number  :string
#  phone       :string
#  fax         :string
#  website     :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class SuppliersController < ApplicationController

  before_action :authenticate_user!

  def index
    @companies = current_user.suppliers
  end

  def new
    @company = Supplier.new
    render 'companies/new'
  end

  def create
    @company = Supplier.new(supplier_params)
    if @company.save
      redirect_to companies_path
    else
      render 'companies/new'
    end
  end


  private


    def supplier_params
      params.require(:supplier).permit(:name, :email, :vat_number, :description).merge(company_id: current_user.company_id)
    end
end
