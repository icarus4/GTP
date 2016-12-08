// VENDOR
import Vue from 'vue'
import Axios from 'axios'

// COMPONENTS
import TodoList from '../components/todo-list.vue'
import Test from '../components/test.vue'

// Add Rails' CSRF token header to requests
Axios.defaults.headers.common['X-CSRF-Token'] = document.querySelector('meta[name="csrf-token"]').getAttribute('content')

// GLOBAL COMPONENT
new Vue({
  el: '#app',
  components: {
    'todo-list': TodoList,
    'test': Test
  }
})
