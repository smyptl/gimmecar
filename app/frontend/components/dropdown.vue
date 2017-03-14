<script>
  import EventListener from 'Utils/event_listener.js';

  export default {
    data () {
      return {
        open: false,
      }
    },
    methods: {
      toggleDropdown (e) {
        e.preventDefault();
        this.open = (this.open == false)
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
          this.open = false
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
    slot(v-if='open' name='dropdown-menu')
</template>

<style lang='stylus'>
  @import '~Styles/global/colors'
  @import '~Styles/global/layout'

  .dropdown-menu
    position: absolute
    top: 125%

    width: 15rem

    ul
      float: left
      width: 100%

      list-style: none
      background: #ffffff

      border-radius: 0.125rem
      box-shadow: 0 3.125rem 6.25rem rgba(50, 50, 50, .1), 0 0.5rem 2rem rgba(150, 150, 150, 0.15), 0 0.125rem 1rem rgba(0, 0, 0, .1), 0 -0.0625rem 0.0625rem rgba(0, 0, 0, 0.02)

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

      padding: $padding-sm

</style>
