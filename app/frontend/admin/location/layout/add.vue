<script>
  import Snabbt from 'snabbt.js'
  import EventListener from 'Utils/event_listener'

  export default {
    data() {
      return {
        event_listener: null,
      }
    },
    mounted() {
      this.event_listener = EventListener.listen(window, 'click', (e) => {
        if (!document.querySelector('#add-link').contains(e.target)) {
          this.closeAdd()
        }
      })
    },
    destroyed() {
      this.event_listener.remove()
    },
    methods: {
      closeAdd() {
        this.$emit('close-add')
      },
      addEnter(el, done) {
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
      addLeave(el, done) {
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
  }
</script>

<template lang='pug'>
  transition(v-on:enter="addEnter" v-on:leave="addLeave")
    #add-container(@click='closeAdd')
      router-link.link(:to="{ name: 'new_rental' }") Rental
      router-link.link(:to="{ name: 'quote' }") Quote

      <!--router-link(:to="{ name: 'new_reservation' }")-->
        <!--svg(xlmns='http://www.w3.org/2000/svg' viewBox='-50 -50 1100 1100' preserveAspectRatio='xMinYMin')-->
          <!--path(d='M857.1 142.9q29.1 0 50.3 21.2t21.2 50.2v714.3q0 29 -21.2 50.2t-50.3 21.2H71.4q-29 0 -50.2 -21.2T0 928.6V214.3q0 -29 21.2 -50.2t50.2 -21.2h71.5V89.3q0 -36.8 26.2 -63.1T232.1 0h35.8q36.8 0 63 26.2t26.2 63.1v53.6h214.3V89.3q0 -36.8 26.3 -63.1T660.7 0h35.7q36.9 0 63.1 26.2t26.2 63.1v53.6h71.4zM642.9 89.3V250q0 7.8 5 12.8t12.8 5.1h35.7q7.8 0 12.9 -5.1t5 -12.8V89.3q0 -7.8 -5 -12.8t-12.9 -5.1h-35.7q-7.8 0 -12.8 5.1t-5 12.8zm-428.6 0V250q0 7.8 5 12.8t12.8 5.1h35.8q7.8 0 12.8 -5.1t5 -12.8V89.3q0 -7.8 -5 -12.8t-12.8 -5.1h-35.8q-7.8 0 -12.8 5.1t-5 12.8zm642.8 839.3V357.1H71.4v571.5h785.7zM500 607.1h125q7.8 0 12.8 5.1t5.1 12.8v35.7q0 7.8 -5.1 12.8t-12.8 5.1H500v125q0 7.8 -5 12.8t-12.9 5h-35.7q-7.8 0 -12.8 -5t-5 -12.8v-125h-125q-7.8 0 -12.9 -5.1t-5 -12.8V625q0 -7.8 5 -12.8t12.9 -5.1h125v-125q0 -7.8 5 -12.8t12.8 -5h35.7q7.9 0 12.9 5t5 12.8v125z')-->

        <!--span Reservation-->

</template>

<style lang='stylus' scoped>
  @import '~Styles/global/colors'
  @import '~Styles/global/layout'
  @import '~Styles/global/type'

  #add-container
    position: absolute
    top: 2rem
    right: 0
    z-index: 11
    float: left

    background: $white
    border-radius: 0.25rem
    box-shadow: 0 3.125rem 6.25rem rgba(50, 50, 50, .1), 0 0.5rem 2rem rgba(150, 150, 150, 0.15), 0 0.125rem 1rem rgba(0, 0, 0, .1)

  a
    display: block
    padding: $padding-default

    text-align: center
    font-size: 1.125rem
    font-weight: 700

  a:not(:last-of-type)
    border-bottom: 0.125rem solid $border-color-light


  svg
    display: block
    width: 2rem
    height: 2rem
    margin: 0 auto 1rem

    fill: #bababa

  span
    display: block

    font-weight: 600
    font-size: $font-size-default
    text-transform: uppercase

</style>
