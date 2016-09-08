# == Schema Information
#
# Table name: items
#
#  id                   :integer          not null, primary key
#  company_id           :integer          not null
#  item_series_id       :integer
#  available_count      :integer          default(0), not null
#  on_hand_count        :integer          default(0), not null
#  cost_per_unit        :integer
#  wholesale_price      :integer
#  retail_price         :integer
#  status               :integer          default(0), not null
#  weight_unit          :integer
#  weight_value         :decimal(10, 2)
#  manufactured_by_self :boolean          default(FALSE), not null
#  expirable            :boolean          default(TRUE), not null
#  sku                  :text
#  name                 :text             default(""), not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  image                :string
#

class ItemsController < ApplicationController
  def index
    @items = current_company.items.includes(item_series: [:brand, :manufacturer]).order(:item_series_id)
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
    @item = Item.includes(:variants, item_price_lists: :price_list).find_by(id: params[:id])
    redirect_to items_path unless @item
  end

  def upload_image
    item = Item.find_by!(id: params[:id], company: current_company)
    item.image = params[:item][:image]
    if item.save
      redirect_to item_path(item)
    else
      flash['alert'] = '上傳失敗'
      redirect_to item_path(item)
    end
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
