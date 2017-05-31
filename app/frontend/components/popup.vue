<script>
  import EventListener from 'Utils/event_listener.js'

  import IconCancel from 'Components/icons/cancel.vue'

  export default {
    props: {
      allow_close: {
        type: Boolean,
        default: false,
      },
    },
    components: {
      IconCancel,
    },
    methods: {
      closePopup () {
        this.$emit('close')
      },
    },
  };
</script>

<template lang='pug'>
  .popup-wrapper(role='dialog' tabindex='0' @keyup.esc='close($event)')
    .popup
      .popup-container
        .popup-content
          a.link-danger#cancel-button(@click='closePopup')
            icon-cancel
          slot

</template>

<style lang='stylus' scoped>
  @import '~Styles/global/colors'
  @import '~Styles/global/layout'
  @import '~Styles/global/type'

  .popup
    position: fixed
    top: 0
    bottom: 0
    left: 0
    right: 0
    z-index: 100

    overflow-x: hidden
    overflow-y: hidden
    padding: $margin-lg $margin-default

    outline: none

    background: rgba(25, 25, 34, 0.65)
    transition: all 0.25s ease
    opacity: 1

  .popup-container
    max-height: 100%
    max-width: 46rem
    margin-left: auto
    margin-right: auto
    text-align: center

  .popup-content
    display: inline-block
    z-index: 101

    opacity: 1
    max-width: 100%
    transition: all 0.375s ease
    background: #ffffff
    border-radius: 0.25rem
    box-shadow: 0 0.0625rem 0.5rem $black-light, 0 0.0625rem 1.5rem $black-light, 0 0.0625rem 0.125rem $silver-dark

    text-align: left

  #cancel-button
    position: absolute
    top: $margin-default + 0.0625rem
    right: $margin-default
    height: 1.25rem
    width: 1.25rem
    z-index: 2

</style>
