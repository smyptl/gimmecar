<script>
  import IsUndefined from 'lodash/isUndefined'

  export default {
    mounted() {
      window.card.mount(this.$el)

      let self = this

      card.addEventListener('change', (event) => {
        if (IsUndefined(event.error)) {
          self.$emit('clear-error')
        } else {
          self.$emit('add-error', event.error.message)
        }
      });
    },
    beforeDestroy() {
      window.card.unmount()
    },
  }
</script>

<template lang='pug'>
  #stripe-credit-card-mount.input-field
</template>

<style lang='stylus'>
  .__PrivateStripeElement
    flex: 1
    align-self: center
</style>
