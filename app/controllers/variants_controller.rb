# == Schema Information
#
# Table name: variants
#
#  id              :integer          not null, primary key
#  product_id      :integer          not null
#  sku             :string
#  name            :string
#  buy_price       :integer
#  cost_per_unit   :integer
#  retail_price    :integer
#  wholesale_price :integer
#  available_count :integer          default(0), not null
#  on_hand_count   :integer          default(0), not null
#  weight_value    :decimal(8, 2)
#  weight_unit_id  :integer
#  description     :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class VariantsController < ApplicationController
  def new
    @product = Product.find(params[:product_id])
    @variant = @product.variants.build
  end

  def create
    @product = Product.find(params[:product_id])
    @variant = @product.variants.build(variant_params)
    if @variant.save
      redirect_to product_path(@product)
    else
      render :new
    end
  end

  def edit
    @variant = Variant.find params[:id]
  end

  def update
    @variant = Variant.find params[:id]
    if @variant.update(variant_params)
      redirect_to product_path(@variant.product)
    else
      render :edit
    end
  end

  def destroy
  end


  private


    def variant_params
      params.require(:variant).permit(:sku, :name, :weight_value, :weight_unit_id, :wholesale_price, :cost_per_unit, :retail_price, :buy_price, :description)
    end
end
