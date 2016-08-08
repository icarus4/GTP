// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {
  $("tr[data-link]").click(function(e) {
    e.preventDefault();
    window.location = $(this).data("link");
  });
})


new Vue({
  el: '#new-item-form',
  data: {
    options: {
      brands: [],
      manufacturers: [],
      storage_and_transport_conditions: [
        { id: 1, name: '冷凍' },
        { id: 2, name: '冷藏' },
        { id: 3, name: '18度C' },
        { id: 4, name: '常溫' },
        { id: 5, name: '其他' },
      ],
    },
    series: {
      brand_id: 0,
      manufacturer_id: 0,
      storage_and_transport_condition_id: 0,
      storage_and_transport_condition_note: "",
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
    item: null,
    items: [],
    new_brand_name: "",
    new_manufacturer: { location_type: 'domestic' },
  },
  created: function() {
    this.item = _.cloneDeep(this.itemTemplate)
  },
  ready: function() {
    this.getBrandList()
    this.getManufacturerList()
  },
  methods: {
    submitForm: function() {
      that = this
      $.ajax({
        url: "/api/v1/items",
        method: 'POST',
        dataType: 'JSON',
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
        data: {item_series: that.series, item: that.item}
      }).done(function(data) {
        alert('成功建立商品')
      }).fail(function(data) {
        alert('建立商品失敗')
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
