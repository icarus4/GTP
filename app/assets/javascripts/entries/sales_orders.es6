import Vue from 'vue'
import Vuex from 'vuex'
import store from '../stores/sales_orders.es6'
import SalesOrderComponent from '../components/sales_orders/sales_order.vue'
import Test from '../libs/test.es6'

Vue.use(Vuex)

new Vue({
  el: '#sales-order',
  store,
  components: {
    'sales-order-component': SalesOrderComponent
  }
})
