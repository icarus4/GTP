class Procurements::VoidProcurementService
  include Service

  def initialize(procurement)
    raise ArgumentError unless procurement.is_a?(Procurement)
    @procurement = procurement
  end

  def call
    ActiveRecord::Base.transaction do
      line_items.each do |line_item|
        # TODO:
        # 1. 已接收商品被販售：則此對應進貨單無法作廢。需先把對應商品銷貨單取消，才可作廢進貨單

        # 2. 已接收商品入庫，被移動，然後作廢進貨單：應返回數量，即可。
        # 2-1. 確認 line_item.location_variant.quantity 是否與 line_item.quantity 相同
        #      若相同則
        #        destroy location_variant
        #        destroy variant
        #        line_item.bin_location_id = nil
        #        line_item.variant_id = nil
        #        line_item.location_variant_id = nil
        #      若 line_item.location_variant.quantity > line_item.quantity 則
        #        location_variant.quantity - line_item.quantity
        #        line_item.bin_location_id = nil
        #        line_item.variant_id = nil
        #        line_item.location_variant_id = nil
        location_variant = line_item.location_variant
        if location_variant.quantity < line_item.quantity
          raise "location_variant.quantity < line_item.quantity"
        elsif location_variant.quantity == line_item.quantity
          location_variant.destroy!
          line_item.variant.destroy!
        elsif location_variant.quantity > line_item.quantity
          location_variant.quantity -= line_item.quantity
        end
        line_item.update!(procurement_id: nil, variant_id: nil, location_variant_id: nil, bin_location_id: nil)

        # TODO:
        # 3. 被移動的商品 又被拿去銷售：不可作廢單據，須先刪除相關商品銷貨單後，方可作廢。然後，再返回相關商品數量。
      end
      
      @procurement.purchase_order.active!
      @procurement.destroy!
    end
  end

  private

    def line_items
      @line_items ||= @procurement.purchase_order_line_items
    end
end
