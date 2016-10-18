// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

if (document.getElementById('new-purchase-order-form'))
{
  var ItemSelectorComponent = Vue.extend({
    template: '#item-selector-component',
    props: {
      item: Object,
      available_items: Array,
      index: Number
    },
    methods: {
      pressDeleteButton: function(index) {
        this.$dispatch('press-delete-button', index)
      }
    }
  })

  // Vue.component('item-selector-component', ItemSelectorComponent)

  new Vue({
    el: "#new-purchase-order-form",
    components: {
      'item-selector-component': ItemSelectorComponent
    },
    data: {
      order: {
        items: [{}]
      },
      item_template: {
        id: null,
        quantity: 1,
        unit_price: null,
        tax_rate: null
      },
      price_list: null,
      options: {
        suppliers: [],
        locations: [],
        price_lists: [],
        items: [],
        stockable_locations: [],
      }
    },
    ready: function() {
      this.getSupplierList()
      this.getLocationList()
      this.getStockableLocationList()
      this.getPriceList()
      this.getItemList()
    },
    methods: {
      getSupplierList: function() {
        var that = this
        $.ajax({
          url: "/api/v1/suppliers",
          method: "GET",
          dataType: "json"
        }).done(function(data) {
          that.options.suppliers = data.suppliers
        })
      },
      getLocationList: function() {
        var that = this
        $.ajax({
          url: "/api/v1/locations",
          method: "GET",
          dataType: "json"
        }).done(function(data) {
          that.options.locations = data.locations
        })
      },
      getStockableLocationList: function() {
        var that = this
        $.ajax({
          url: "/api/v1/locations/holds_stock",
          method: "GET",
          dataType: "json"
        }).done(function(data) {
          that.options.stockable_locations = data.locations
        })
      },
      getPriceList: function() {
        var that = this
        $.ajax({
          url: "/api/v1/price_lists/purchase",
          method: "GET",
          dataType: "json"
        }).done(function(data) {
          that.options.price_lists = data.price_lists
        })
      },
      getItemList: function() {
        var that = this
        $.ajax({
          url: "/api/v1/items",
          method: "GET",
          dataType: "json"
        }).done(function(data) {
          that.options.items = data.items
        })
      },
      addNewItem: function() {
        this.order.items.push(_.cloneDeep(this.item_template))
      },
      removeItem: function(index) {
        this.order.items.$remove(this.order.items[index])
      }
    }
  })
}
