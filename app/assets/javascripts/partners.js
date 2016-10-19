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
    computed: {
      total: function() {
        var total = 0
        if (_.isInteger(this.item.quantity) && _.isInteger(this.item.unit_price)) {
          total = this.item.quantity * this.item.unit_price
        }
        this.item.total = total
        return total
      },
      available_count: {
        get: function() {
          if (!_.isInteger(this.item.id)) {
            return ''
          }
          var that = this
          var selected_item = _.find(this.available_items, function(item) {
            return item.id == that.item.id
          })
          return parseInt(selected_item.available_count) + parseInt(this.item.quantity)
        }
      }
    },
    methods: {
      pressDeleteButton: function(index) {
        this.$dispatch('press-delete-button', index)
      }
    }
  })

  new Vue({
    el: "#new-purchase-order-form",
    components: {
      'item-selector-component': ItemSelectorComponent
    },
    data: {
      order: {
        items: [],
        subtotal: 0,
        total_are_tax_inclusive: null,
        total_tax: 0,
        total_amount: 0,
      },
      item_template: {
        id: null,
        quantity: 1,
        unit_price: null,
        tax_rate: null,
        total: 0
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
    computed: {
      total_units: function() {
        var total_units = 0
        this.order.items.forEach(function(item) {
          // 選定了商品時才計入
          if (_.isInteger(item.quantity) && _.isInteger(item.id)) {
            total_units += item.quantity
          }
        })
        return total_units
      },
      subtotal: function() {
        var subtotal = 0
        this.order.items.forEach(function(item) {
          if (_.isInteger(item.total) && _.isInteger(item.id)) {
            subtotal += item.total
          }
        })
        this.order.subtotal = subtotal
        return subtotal
      },
      total_tax: function() {
        var total_tax = 0
        var that = this
        this.order.items.forEach(function(item) {
          if (_.isInteger(item.id) && _.isInteger(item.total) && _.isNumber(item.tax_rate)) {
            if (that.order.total_are_tax_inclusive === 'false') {
              total_tax += item.total * item.tax_rate / 100
            }
            else {
              // 推導
              // total_without_tax * (100 + tax_rate) / 100 = total
              // total_without_tax * (100 + tax_rate) / 100 = total_without_tax + tax
              // total_without_tax * (100 + tax_rate) / 100 - total_without_tax = tax
              // total_without_tax * ((100 + tax_rate) / 100 - 1) = tax
              // (total - tax) * ((100 + tax_rate) / 100 - 1) = tax
              // total * ((100 + tax_rate) / 100 - 1) - tax * ((100 + tax_rate) / 100 - 1) = tax
              // total * ((100 + tax_rate) / 100 - 1) = tax + tax * ((100 + tax_rate) / 100 - 1)
              // total * ((100 + tax_rate) / 100 - 1) = tax * (1 + ((100 + tax_rate) / 100 - 1))
              // total * ((100 + tax_rate) / 100 - 1) / (1 + ((100 + tax_rate) / 100 - 1)) = tax
              // total / (1 / ((100 + tax_rate) / 100 - 1) + 1) = tax          
              total_tax += item.total / (1 / ((100 + item.tax_rate) / 100 - 1) + 1)
            }
          }
        })
        total_tax = Math.round(total_tax * 100) / 100
        this.order.total_tax = total_tax
        return total_tax
      },
      total_amount: function() {
        var total_amount = 0
        if (_.isNumber(this.subtotal) && _.isNumber(this.total_tax)) {
          if (this.order.total_are_tax_inclusive === 'false') {
            total_amount = this.subtotal + this.total_tax
          }
          else if (this.order.total_are_tax_inclusive === 'true') {
            total_amount = this.subtotal
          }
        }
        this.order.total_amount = total_amount
        return total_amount
      }
    },
    ready: function() {
      this.getSupplierList()
      this.getLocationList()
      this.getStockableLocationList()
      this.getPriceList()
      this.getItemList()
      this.addNewItem()
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
      },
    }
  })
}
