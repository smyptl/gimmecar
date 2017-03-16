<script>
  import Snabbt from 'snabbt.js'
  import EventListener from 'Utils/event_listener.js';

  export default {
    data () {
      return {
        open: false,
      }
    },
    methods: {
      close () {
        this.open = false
      },
      toggleDropdown (e) {
        e.preventDefault();
        this.open = (this.open == false)
      },
      openDropdown (el, done) {
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
      closeDropdown (el, done) {
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
    mounted () {
      const el = this.$el;
      const toggle = el.querySelector('[data-toggle="dropdown"]');

      if (toggle) {
        toggle.addEventListener('click', this.toggleDropdown);
      }
      this._closeEvent = EventListener.listen(window, 'click', (e) => {
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
  };
</script>

<template lang='pug'>
  .dropdown-container
    slot
    transition(v-on:enter="openDropdown" v-on:leave="closeDropdown")
      slot(v-if='open' name='dropdown-menu' @click='close')
</template>

<style lang='stylus'>
  @import '~Styles/global/colors'
  @import '~Styles/global/layout'
  @import '~Styles/global/type'

  .dropdown-menu
    position: absolute
    z-index: 2
    top: 125%

    width: 15rem

    ul
      float: left
      width: 100%

      list-style: none
      background: #ffffff

      border-radius: 0.125rem
      box-shadow: 0 3.125rem 6.25rem rgba(50, 50, 50, .1), 0 0.5rem 2rem rgba(150, 150, 150, 0.15), 0 0.125rem 1rem rgba(0, 0, 0, .1)

    li
      float: left
      width: 100%

      border-bottom: 0.0625rem solid $border-color-light

      font-size: $font-size-default + 0.125rem
      font-weight: 600

    li:last-of-type
      border-bottom: 0

    a
      float: left
      width: 100%

      padding: $padding-sm + $padding-ex-sm

</style>
