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
    @product.variants.build
  end

  def create
    @product = current_company.products.build(product_params)
    # TODO: check supplier_id, product_type_id, brand_id
    if @product.save
      redirect_to product_path(@product)
    else
      render :new
    end
  end

  def show
    @product = Product.find_by(id: params[:id])
    redirect_to products_path unless @product
  end


  private


    def product_params
      params.require(:product)
        .permit(
          :name,
          :supplier_id,
          :product_type_id,
          :brand_id,
          :description,
          variants_attributes: [:sku, :cost_per_unit, :on_hand_count, :buy_price, :wholesale_price, :retail_price]
        )
    end
end
