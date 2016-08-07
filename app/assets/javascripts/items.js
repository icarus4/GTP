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
      storage_and_transport_conditions: [
        { id: 1, name: '冷藏' },
        { id: 2, name: '冷凍' },
      ],
    },
    series: {
      manufacturer: null,
      brand_id: 0,
      storage_and_transport_condition_id: 0,
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
  },
  created: function() {
    this.item = _.cloneDeep(this.itemTemplate)
  },
  ready: function() {
    this.getBrandList()
  },
  methods: {
    submitForm: function() {

    },
    getBrandList: function() {
      that = this;
      $.ajax({
        url: "/api/v1/brands"
      }).done(function(data) {
        that.options.brands = data.brands
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
        alert(data.errors.full_messages)
      })
    }
  }
});
