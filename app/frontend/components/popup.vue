<script>
  import Snabbt from 'snabbt.js'
  import EventListener from 'Utils/event_listener.js'

  import IconCancel from 'Components/icons/cancel.vue'

  export default {
    props: {
      allow_close: {
        type: Boolean,
        default: false,
      },
    },
    data () {
      return {
        show: false,
      }
    },
    components: {
      IconCancel,
    },
    mounted () {
      this.show = true
    },
    methods: {
      closePopup () {
        return this.show = false
      },
      afterLeave(el) {
        this.$emit('closed')
      },
    },
  };
</script>

<template lang='pug'>
  transition(name='popup' v-on:after-leave='afterLeave')
    .popup-wrapper(v-if='show' role='dialog' tabindex='0' @keyup.esc='close($event)')
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
    opacity: 1
    transition: all 0.275s ease

  .popup-container
    max-height: 100%
    max-width: 46rem
    margin-left: auto
    margin-right: auto
    text-align: center

  .popup-content
    display: inline-block
    z-index: 101
    max-width: 100%

    opacity: 1
    transition: all 0.375s ease
    background: #ffffff
    border-radius: 0.25rem

    text-align: left

  .popup-enter-active
    .popup
      opacity: 0

    .popup-content
      opacity: 0
      transform: translateY(-0.5rem) perspective( 10000px )

  .popup-leave-active
    opacity: 0
    transition: all 0.375s ease

    .popup-content
      opacity: 0
      transitiona: all 0.275s ease
      transform: translateY(0.625rem) perspective( 10000px )

  #cancel-button
    position: absolute
    top: $margin-default + 0.0625rem
    right: $margin-default
    height: 1.25rem
    width: 1.25rem
    z-index: 2

</style>
