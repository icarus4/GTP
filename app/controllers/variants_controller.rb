# == Schema Information
#
# Table name: variants
#
#  id                 :integer          not null, primary key
#  item_id            :integer          not null
#  quantity           :integer          default(0), not null
#  manufacturing_date :date
#  expiry_date        :date
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
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
      params.require(:variant).permit(:manufacturing_date, :expiry_date, :quantity)
    end
end
