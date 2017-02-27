<script>
  import Snabbt from 'snabbt.js'
  import EventListener from 'Utils/event_listener'

  export default {
    data () {
      return {
        event_listener: null,
      }
    },
    mounted () {
      this.event_listener = EventListener.listen(window, 'click', (e) => {
        if (!document.querySelector('#navigation').contains(e.target)) {
          this.closeNav()
        }
      })
    },
    destroyed () {
      this.event_listener.remove()
    },
    methods: {
      closeNav () {
        this.$emit('close-nav')
      },
      navEnter (el, done) {
        Snabbt(el, {
          scale: [1, 1],
          fromScale: [0.95, 0.95],
          position: [0, 0, 0],
          fromPosition: [-5, -5, -500],
          opacity: 1,
          fromOpacity: 0.05,
          duration: 150,
          complete() {
            done()
          },
        });
      },
      navLeave (el, done) {
        Snabbt(el, {
          scale: [0.95, 0.95],
          fromScale: [1, 1],
          position: [-5, -5, -500],
          fromPosition: [0, 0, 0],
          opacity: 0.05,
          fromOpacity: 1,
          duration: 100,
          complete() {
            done()
          },
        });
      },
    },
  }
</script>

<template lang='pug'>
  transition(v-on:enter="navEnter" v-on:leave="navLeave")
    nav(@click='closeNav')
      ul.list-horizontal
        li
          router-link(:to="{ name: 'dashboard' }")
            svg(xlmns='http://www.w3.org/2000/svg' viewBox='0 -50 1050 1050' preserveAspectRatio='xMinYMin')
              path(d='M406 672q34 -56 214 -284t194 -220q12 6 -96 278t-138 326q-50 86 -136 36t-38 -136zm94 -380q-168 0 -284 127t-116 311q0 30 2 46 2 22 -12 37t-34 17 -36 -12 -18 -34q0 -8 -1 -26t-1 -28q0 -226 145 -382t355 -156q72 0 134 18l-70 86q-40 -4 -64 -4zm362 62q138 154 138 376 0 38 -2 56 -2 20 -16 33t-34 13l-4 0q-22 -4 -35 -20t-11 -36q2 -14 2 -46 0 -150 -80 -268 6 -14 20 -51t22 -57z')
            span Dashboard

        li
          router-link(:to="{ name: 'rentals' }")
            svg(xlmns='http://www.w3.org/2000/svg' viewBox='-35 -15 1050 1050' preserveAspectRatio='xMinYMin')
              path(d='M464.3 285.7q0 -44.6 -31.3 -75.9t-75.9 -31.2 -75.8 31.2T250 285.7q0 23.5 10.6 46.3 -22.9 -10.6 -46.3 -10.6 -44.7 0 -75.9 31.3t-31.3 75.9 31.3 75.9 75.9 31.2 75.9 -31.2 31.2 -75.9q0 -23.5 -10.6 -46.3 22.9 10.6 46.3 10.6 44.7 0 75.9 -31.3t31.3 -75.9zm474.9 392.9q0 9.5 -27.4 36.8T875 742.7q-5 0 -15.9 -8.9t-20.4 -18.4 -21.5 -22.3 -13.6 -14.5L750 732.1l122.8 122.8q15.6 15.6 15.6 38 0 23.4 -21.8 45.2t-45.2 21.7q-22.3 0 -37.9 -15.6L409 569.8q-98.2 73.1 -203.6 73.1 -91 0 -148.2 -57.2T0 437.5Q0 348.2 53 262.8T191.4 124.4t174.7 -53q90.9 0 148.1 57.2t57.2 148.2q0 105.5 -73.1 203.7l198.1 198.1L750 625q-1.7 -1.7 -14.5 -13.7t-22.3 -21.5 -18.4 -20.3 -9 -15.9q0 -9.5 27.4 -36.9T750 489.4q7.3 0 12.8 5.6 3.4 3.3 25.7 24.8t45.8 44.4 48.2 48 40.8 43.5 15.9 22.9z')
            span Rentals

        li
          router-link(:to="{ name: 'reservations' }")
            svg(xlmns='http://www.w3.org/2000/svg' viewBox='-85 -50 1100 1100' preserveAspectRatio='xMinYMin')
              path(d='M71.4 928.6h785.7V357.1H71.4v571.5zM285.7 250V89.3q0 -7.8 -5 -12.8t-12.8 -5.1h-35.8q-7.8 0 -12.8 5.1t-5 12.8V250q0 7.8 5 12.8t12.8 5.1h35.8q7.8 0 12.8 -5.1t5 -12.8zm428.6 0V89.3q0 -7.8 -5 -12.8t-12.9 -5.1h-35.7q-7.8 0 -12.8 5.1t-5 12.8V250q0 7.8 5 12.8t12.8 5.1h35.7q7.8 0 12.9 -5.1t5 -12.8zm214.3 -35.7v714.3q0 29 -21.2 50.2t-50.3 21.2H71.4q-29 0 -50.2 -21.2T0 928.6V214.3q0 -29 21.2 -50.2t50.2 -21.2h71.5V89.3q0 -36.8 26.2 -63.1T232.1 0h35.8q36.8 0 63 26.2t26.2 63.1v53.6h214.3V89.3q0 -36.8 26.3 -63.1T660.7 0h35.7q36.9 0 63.1 26.2t26.2 63.1v53.6h71.4q29.1 0 50.3 21.2t21.2 50.2z')
            span Reservations

        li
          router-link(:to="{ name: 'rates' }")
            svg(xlmns='http://www.w3.org/2000/svg' viewBox='-25 -65 1150 1150' preserveAspectRatio='xMinYMin')
              path(d='M365 58q-108.75 0 -185 76.25t-76.25 183.75 76.25 183.75l158.75 155 286.25 286.25 365 -365q-368.75 -368.75 -441.25 -443.75 -76.25 -76.25 -183.75 -76.25zm0 -105q151.25 0 258.75 107.5 108.75 112.5 440 443.75 30 31.25 30 73.75t-30 73.75l-365 365q-30 30 -73.75 30t-73.75 -30l-270 -270q-8.75 -6.25 -18.75 -15l-156.25 -156.25q-106.25 -106.25 -106.25 -257.5t106.25 -257.5q107.5 -107.5 258.75 -107.5zm0 286.25q-32.5 0 -55.625 23.125t-23.125 55.625 23.125 55 55.625 22.5 55 -22.5 22.5 -55 -22.5 -55.625 -55 -23.125zm0 -51.25q53.75 0 91.875 38.125t38.125 91.875 -38.125 91.875 -91.875 38.125 -91.875 -38.125 -38.125 -91.875 38.125 -91.875 91.875 -38.125z')
            span Rates

        li
          router-link(:to="{ name: 'vehicles' }")
            svg(xlmns='http://www.w3.org/2000/svg' viewBox='-5 1 950 950' preserveAspectRatio='xMinYMin')
              path(d='M464.5 53.5q184.5 0 315.5 131t131 315.5 -131 315.5 -315.5 131 -315.5 -131 -131 -315.5 131 -315.5 315.5 -131zm0 112q-106.5 0 -192.5 62t-122 161l629 0q-36 -99 -122 -161t-192.5 -62zm-.5 390q24 0 40.5 -16.5t16.5 -39.5q0 -24 -17 -40t-39.5 -16 -39 16 -16.5 40 16.5 40 38.5 16zm-334 -56q0 124 79 216.5t199 112.5q-2 -137 -83 -233t-195 -96zm391 329q120 -20 199 -112.5t79 -216.5q-114 0 -195 96t-83 233z')
            span Vehicles
</template>

<style lang='stylus' scoped>
  @import '~Styles/global/colors'
  @import '~Styles/global/layout'

  nav
    position: absolute
    top: 2rem
    left: 0
    z-index: 11
    padding-right: $padding-default

    width: 100%
    min-width: 15rem
    max-width: 25rem

  ul
    float: left
    width: 100%
    padding: $padding-sm 0

    background: #ffffff
    border-radius: 0.25rem
    box-shadow: 0 3.125rem 6.25rem rgba(50, 50, 50, .1), 0 0.5rem 2rem rgba(150, 150, 150, 0.15), 0 0.125rem 1rem rgba(0, 0, 0, .1)

    list-style: none
    text-align: left

    li
      width: 100%

      > a
        float: left
        width: 100%
        padding-left: $padding-default

        font-size: 1.25rem
        font-weight: 600
        line-height: 2.75rem
        fill: $blue

        svg
          height: 1.75rem
          width: 1.75rem
          float: left
          margin: 0.5rem ($margin-sm + $margin-ex-sm)
          margin-left: 0
          fill: #bababa

      > a.active
        color: $text-color-dark-blue

        svg
          fill: $text-color-dark-blue
</style>
