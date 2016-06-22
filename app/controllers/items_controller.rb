# == Schema Information
#
# Table name: items
#
#  id              :integer          not null, primary key
#  company_id      :integer
#  supplier_id     :integer
#  item_type_id    :integer
#  brand_id        :integer
#  unit            :string
#  status          :integer          default(0), not null
#  available_count :integer          default(0), not null
#  on_hand_count   :integer          default(0), not null
#  sku             :string
#  name            :string(255)      default(""), not null
#  description     :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
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
    if @item.save
      redirect_to item_path(@item)
    else
      render :new
    end
  end

  def show
    @item = Item.includes(:variants).find_by(id: params[:id])
    redirect_to items_path unless @item
  end


  private


    def item_params
      params.require(:item).permit(
        :name,
        :supplier_id,
        :item_type_id,
        :brand_id,
        :description,
        :initial_location_id,
        :on_hand_count,
        :sku,
        :unit,
        variants_attributes: [:manufacturing_date, :expiry_date]
      )
    end
end
