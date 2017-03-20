<script>
  import Popup from 'Components/popup'

  export default {
    data () {
      return {
        open: false,
      }
    },
    mounted () {
      this.open = true
    },
    components: {
      Popup
    },
    methods: {
      close () {
        this.open = false
      }
    },
  }
</script>

<template lang='pug'>
  popup(v-if='open')
    h1 3
    p adf
    p TEST
</template>

<style lang='stylus' scoped>
  p
    height: 2000px
</style>
