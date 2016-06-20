# == Schema Information
#
# Table name: variants
#
#  id              :integer          not null, primary key
#  item_id         :integer          not null
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
    @item = Item.find(params[:item_id])
    @variant = @item.variants.build
  end

  def create
    @item = Item.find(params[:item_id])
    @variant = @item.variants.build(variant_params)
    if @variant.save
      redirect_to item_path(@item)
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
      redirect_to item_path(@variant.item)
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
