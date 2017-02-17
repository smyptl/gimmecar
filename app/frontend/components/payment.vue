<script>
  export default {
    mounted () {
      window.card.mount(this.$el)
    },
    beforeDestroy () {
      window.card.unmount()
    },
  }
</script>

<template lang='pug'>
  #stripe-credit-card-mount.input-field
</template>

<style lang='stylus'>
  @import '~Styles/global/colors'
  @import '~Styles/global/layout'

  #stripe-credit-card-mount
    padding-top: 0
    padding-bottom: 0

    display: flex
    flex-direction: row

  .__PrivateStripeElement
    flex: 1
    align-self: center

</style>
