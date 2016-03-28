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

  def create
    @product = current_company.products.build(product_params)
    # TODO: check supplier_id, product_type_id, brand_id
    begin
      ActiveRecord::Base.transaction do
        @product.save!
        @variant = @product.variants.create!(
          sku:             params[:product][:sku],
          cost_per_unit:   params[:product][:initial_cost_price].to_i,
          on_hand_count:   params[:product][:initial_on_hand_count].to_i,
          buy_price:       params[:product][:buy_price].to_i,
          wholesale_price: params[:product][:wholesale_price].to_i,
          retail_price:    params[:product][:retail_price].to_i,
        )
        redirect_to product_path(@product)
      end
    rescue
      render :new
    end
  end

  def show
    @product = Product.find_by(id: params[:id])
    redirect_to products_path unless @product
  end


  private


    def product_params
      params.require(:product).permit(:name, :supplier_id, :product_type_id, :brand_id, :description)
    end
end
