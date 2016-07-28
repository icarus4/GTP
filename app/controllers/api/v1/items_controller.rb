class Api::V1::ItemsController < Api::V1::BaseController
  def index
    items = current_company.items.includes(:variants).joins(:variants)
    render json: { items: items.as_json(include: :variants, except: [:created_at, :updated_at]) }
  end

  def stock_info
    item = Item.find_by(id: params[:id], company: current_company)
    # items = current_company.items.includes( { variants: { location_variants: { bin_location: :location } } } ).joins(:variants).uniq
    # _items = current_company.items.includes( { locations: { location_variants: { bin_location: :location } } } ).joins(:variants).uniq

    # {
    #   items: [
    #     {
    #       name: 'xxx',
    #       bin_locations: [
    #         {
    #           name: 'xxx',
    #           variants: [
    #             {
    #               quantity: x,
    #               expiry_date: 'xxxx-xx-xx',
    #             }
    #           ]
    #         }
    #       ]
    #     },
    #     ...
    #   ]
    # }
    item_hash = {
      item: {
        name: item.name
      }
    }


    #
    #
    # return_hash = {
    #   items: items
    # }
    #
    # render json: {
    #   items: items.as_json(
    #     include: { variants: {
    #         include: { location_variants: {
    #             include: { bin_location: {
    #                 include: :location
    #             } }
    #         } }
    #     } },
    #     except: [:created_at, :updated_at]
    #   )
    # }
    render json: item_hash
  end
end
