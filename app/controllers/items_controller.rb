# == Schema Information
#
# Table name: items
#
#  id           :integer          not null, primary key
#  company_id   :integer
#  supplier_id  :integer
#  item_type_id :integer
#  brand_id     :integer
#  status       :integer          default(0), not null
#  name         :string(255)      default(""), not null
#  description  :text
#  deleted_at   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class ItemsController < ApplicationController
  def index
    @items = current_company.items.includes(:supplier, :brand)
  end

  def new
    @item = current_company.items.build
    @item.variants.build
  end

  def create
    @item = current_company.items.build(item_params)
    # TODO: check supplier_id, item_type_id, brand_id
    if @item.save
      redirect_to item_path(@item)
    else
      render :new
    end
  end

  def show
    @item = Item.find_by(id: params[:id])
    redirect_to items_path unless @item
  end


  private


    def item_params
      params.require(:item)
        .permit(
          :name,
          :supplier_id,
          :item_type_id,
          :brand_id,
          :description,
          variants_attributes: [:sku, :name, :cost_per_unit, :on_hand_count, :buy_price, :wholesale_price, :retail_price]
        )
    end
end
