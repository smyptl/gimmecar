<script>
  import Snabbt from 'snabbt.js'
  import EventListener from 'Utils/event_listener.js';

  export default {
    props: {
      allow_close: {
        type: Boolean,
        default: false,
      },
    },
    mounted () {
      const el = this.$el.getElementsByClassName('popup-container')[0]

      this._closeEvent = EventListener.listen(window, 'click', (e) => {
        console.log(!el.contains(e.target))
        if (!el.contains(e.target)) {
          this.close()
        }
      });
    },
    beforeDestroy () {
      if (this._closeEvent) {
        this._closeEvent.remove();
      }
    },
    methods: {
      close () {
        console.log('close')
      },
      openPopup (el, done) {
        Snabbt(el, {
          scale: [1, 1],
          fromScale: [0.95, 0.95],
          position: [0, 0, 0],
          fromPosition: [5, -5, -500],
          opacity: 1,
          fromOpacity: 0.05,
          duration: 150,
          complete() {
            done()
          },
        })
      },
      closePopup (el, done) {
        Snabbt(el, {
          scale: [0.95, 0.95],
          fromScale: [1, 1],
          position: [5, -5, -500],
          fromPosition: [0, 0, 0],
          opacity: 0.05,
          fromOpacity: 1,
          duration: 100,
          complete() {
            done()
          },
        })
      },
    },
  };
</script>

<template lang='pug'>
  .popup-wrapper(role='dialog' tabindex='0' @keyup.esc='close($event)')
    .popup
      transition(v-on:enter='openPopup' v-on:leave='closePopup')
        .popup-container
          .popup-content
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
    overflow-y: auto
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

</style>
