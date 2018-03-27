<script>
  export default {
    data () {
      return {
        event_listener: null,
      }
    },
    mounted () {
      window.card.mount(this.$el)

      card.addEventListener('change', function(event) {
        var displayError = document.getElementById('stripe-card-errors')
        if (event.error) {
          displayError.textContent = event.error.message
        } else {
          displayError.textContent = ''
        }
      });

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
