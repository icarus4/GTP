// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

new Vue({
  el: "#item-table",
  data: {
    item_series_id: null,
    itemTemplate: {
      name: null,
      sku: null,
      purchase_price: null,
      wholesale_price: null,
      retail_price: null,
      cost_per_unit: null,
      on_hand_count: null,
      item_details: [],
      low_stock_alert_level: null,
    },
    itemDetailTemplate: {
      on_hand_count: null,
      expiry_date: null,
      location_id: 0,
      bin_location_id: 0,
    },
    options: {
      locations: [],
    },
    items: [],
    new_items: [],
  },
  created: function() {
    this.getItemSeriesId()
  },
  ready: function() {
    this.getItemList()
    this.getLocationList()
  },
  methods: {
    getItemSeriesId: function() {
      this.item_series_id = $("input#item-series-id").val()
    },
    getItemList: function() {
      that = this
      $.ajax({
        url: "/api/v1/item_series/" + that.item_series_id + "/items"
      }).done(function(data) {
        that.items = data.items
      })
    },
    getLocationList: function() {
      that = this
      $.ajax({
        url: "/api/v1/locations/holds_stock"
      }).done(function(data) {
        that.options.locations = data.locations
      }).fail(function(err) {
        console.log(err)
      })
    },
    addNewItemForm: function() {
      var new_item = _.cloneDeep(this.itemTemplate)
      new_item.item_details.push(_.cloneDeep(this.itemDetailTemplate))
      this.new_items.push(new_item)
    },
    submitItemForm: function(index) {
      that = this;
      $.ajax({
        url: "/api/v1/item_series/" + that.item_series_id + "/items",
        method: "POST",
        dataType: 'JSON',
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
        data: that.new_items[index]
      }).done(function(data) {
        that.items.push(data.item)
        that.new_items.$remove(that.new_items[index])
      }).fail(function(err) {
        console.log(err)
        alert(err.responseJSON.errors)
      })
    },
    find_bin_locations_by_location_id: function(location_id) {
      if (location_id == 0) {
        return []
      }
      else {
        var selected_location = _.find(this.options.locations, function(location) {
          return location.id == location_id
        })
        return selected_location.bin_locations
      }
    }
  }
})
