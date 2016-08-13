// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

new Vue({
  el: '#new-item-series-form',
  data: {
    options: {
      brands: [],
      manufacturers: [],
      storage_and_transport_conditions: [
        { id: 'freezing',         name: '冷凍' },
        { id: 'refrigeration',    name: '冷藏' },
        { id: 'eighteen_degrees', name: '18度C' },
        { id: 'room_temperature', name: '常溫' },
        { id: 'other',            name: '其他' },
      ],
    },
    series: {
      brand_id: 0,
      name: null,
      sku: null,
      manufacturer_id: 0,
      storage_and_transport_condition: 0,
      storage_and_transport_condition_note: null,
      raw_material: null,
      main_and_auxiliary_material: null,
      food_additives: null,
      warnings: null
    },
    itemTemplate: {
      name: "",
      tags: [],
      description: "",
      on_hand_count: null,
      cost_per_unit: null,
      purchase_price: null,
      wholesale_price: null,
      retail_price: null,
      low_stock_alert_level: null,
    },
    new_brand_name: "",
    new_manufacturer: { location_type: 'domestic' },
  },
  ready: function() {
    this.getBrandList()
    this.getManufacturerList()
  },
  methods: {
    submitForm: function() {
      that = this
      $.ajax({
        url: "/api/v1/item_series",
        method: 'POST',
        dataType: 'JSON',
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
        data: {item_series: that.series}
      }).done(function(data) {
        alert('成功建立商品系列')
        window.location.replace("/item_series/" + data.id)
      }).fail(function(data) {
        console.log(data.errors);
        alert(data.errors)
      })
    },
    getBrandList: function() {
      that = this;
      $.ajax({
        url: "/api/v1/brands"
      }).done(function(data) {
        that.options.brands = data.brands
      })
    },
    getManufacturerList: function() {
      that = this;
      $.ajax({
        url: "/api/v1/manufacturers"
      }).done(function(data) {
        that.options.manufacturers = data.manufacturers
      })
    },
    createBrand: function() {
      that = this;
      $.ajax({
        url: "/api/v1/brands",
        method: 'POST',
        dataType: 'JSON',
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
        data: {brand: {name: that.new_brand_name}}
      }).done(function(data) {
        that.options.brands.push(data.brand)
        that.series.brand_id = data.brand.id
        $("#new-brand-modal").modal('hide')
      }).fail(function(data) {
        console.log(data.errors.full_messages)
      })
    },
    createManufacturer: function() {
      that = this;
      $.ajax({
        url: "/api/v1/manufacturers",
        method: 'POST',
        dataType: 'JSON',
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
        data: {
          name: that.new_manufacturer.name,
          location_type: that.new_manufacturer.location_type,
          registration_number: that.new_manufacturer.registration_number,
          address: that.new_manufacturer.address
        }
      }).done(function(data) {
        that.options.manufacturers.push(data.manufacturer)
        that.series.manufacturer_id = data.manufacturer.id
        $("#new-manufacturer-modal").modal('hide')
      }).fail(function(data) {
        console.log(data.errors.full_messages)
      })
    }
  }
});