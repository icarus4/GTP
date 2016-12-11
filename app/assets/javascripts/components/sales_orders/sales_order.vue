<template>
  <div class="col-md-9">
    {{ count }}
  </div>
</template>

<script>
export default {
  data() {
    return {
      msg: 'hello!!'
    }
  },
  computed: {
    count() {
      return this.$store.state.count
    }
  }
}
</script>
