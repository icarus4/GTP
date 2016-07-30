// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

new Vue({
  el: "#sales-order",
  data: {
    selectedShipToLocation: 0,
    shipToLocations: [
      { id: 0, name: '-- 請選取 --' },
      { id: 1, name: '你家' },
      { id: 2, name: '我家' },
    ],
    shippedOn: '',
    items: [],
    itemTemplate: {
      selectedId: 0,
      quantity: 1,
      unitPrice: null,
      subtotal: 0,
      options: [
        { id: 0, name: '-- 選取貨品 --' },
        { id: 1, name: '紅茶' },
        { id: 2, name: '綠茶' },
      ]
    },
    currentItemId: 0,
  },
  created: function() {
    this.addNewItem()
  },
  methods: {
    getNewItem: function() {
      var item = _.cloneDeep(this.itemTemplate)
      item.id = this.currentItemId
      this.currentItemId++
      return item;
    },
    addNewItem: function() {
      this.items.push(this.getNewItem())
    },
    removeItem: function(item) {
      this.items.$remove(item)
    },
    updateSubtotal: function(item) {
      if (!isNaN(item.quantity) && !isNaN(item.unitPrice)) {
        item.subtotal = item.unitPrice * item.quantity
      }
    }
  },
})
