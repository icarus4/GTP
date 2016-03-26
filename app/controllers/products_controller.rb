# == Schema Information
#
# Table name: products
#
#  id              :integer          not null, primary key
#  company_id      :integer
#  supplier_id     :integer
#  product_type_id :integer
#  brand_id        :integer
#  status          :integer          default(0), not null
#  name            :string(255)      default(""), not null
#  description     :text
#  deleted_at      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class ProductsController < ApplicationController
  def index
    @products = current_company.products.includes(:supplier, :brand)
  end

  def new
    @product = current_company.products.build
  end
end
