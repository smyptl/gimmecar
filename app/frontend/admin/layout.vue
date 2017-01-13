<script>
  import Snabbt from 'snabbt.js'

  import isUndefined from 'lodash/isUndefined'

  export default {
    name: 'layout',
    data () {
      return {
        nav: false,
      }
    },
    methods: {
      openNav () {
        this.nav = true
      },
      closeNav (event) {
        this.nav = false
      },
      navEnter (el, done) {
        Snabbt(el, {
          scale: [1, 1],
          fromScale: [0.95, 0.95],
          position: [0, 0, 0],
          fromPosition: [-10, -10, -500],
          opacity: 1,
          fromOpacity: 0,
          duration: 150,
          complete() {
            el.focus()
            done()
          },
        });
      },
      navLeave (el, done) {
        Snabbt(el, {
          scale: [0.95, 0.95],
          fromScale: [1, 1],
          position: [-10, -10, -500],
          fromPosition: [0, 0, 0],
          opacity: 0,
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
  #gimmecar-app
    header
      h1.logo.root-link
        | GimmeCar
        small Super 8 Redlands

      #navigation.nav-link
        a(@click='closeNav()' v-if='nav')
          svg(xlmns='http://www.w3.org/2000/svg' viewBox='-80 0 875 875' preserveAspectRatio='xMinYMin')
            path(d='M0 759.904q0 -35.624 25.864 -61.488l195.2 -195.2 -195.2 -195.688q-25.864 -25.376 -25.864 -61t25.864 -61 61.244 -25.376 60.756 25.376l195.688 195.688 195.2 -195.688q25.376 -25.376 61 -25.376t61 25.376 25.376 61 -25.376 61l-195.2 195.688 195.2 195.2q25.376 25.864 25.376 61.488t-25.376 61q-24.888 25.376 -61 25.376t-61 -25.376l-195.2 -195.2 -195.688 195.2q-24.888 25.376 -61 25.376t-61 -25.376q-25.864 -25.376 -25.864 -61z')


        a(@click='openNav()' v-else)
          svg(xlmns='http://www.w3.org/2000/svg' viewBox='50 0 950 950' preserveAspectRatio='xMinYMin')
            path(d='M67.832 788.208q0 29.768 21.472 50.996t50.752 21.228h793q29.768 0 50.752 -21.228t20.984 -50.996 -20.984 -50.752 -50.752 -20.984h-793q-29.28 0 -50.752 20.984t-21.472 50.752zm0 -287.92q0 29.768 21.472 50.752t50.752 20.984h793q29.768 0 50.752 -20.984t20.984 -50.752 -20.984 -50.996 -50.752 -21.228h-793q-29.28 0 -50.752 21.228t-21.472 50.996zm0 -288.408q0 29.768 21.472 50.752t50.752 20.984h793q29.768 0 50.752 -20.984t20.984 -50.752 -20.984 -50.996 -50.752 -21.228h-793q-29.28 0 -50.752 21.228t-21.472 50.996z')

        transition(v-on:enter="navEnter" v-on:leave="navLeave")
          nav(v-show='nav' transition)
            ul#main-nav.list-horizontal
              li
                router-link(:to="{ name: 'dashboard' }")
                  svg(xlmns='http://www.w3.org/2000/svg' viewBox='0 -50 1050 1050' preserveAspectRatio='xMinYMin')
                    path(d='M406 672q34 -56 214 -284t194 -220q12 6 -96 278t-138 326q-50 86 -136 36t-38 -136zm94 -380q-168 0 -284 127t-116 311q0 30 2 46 2 22 -12 37t-34 17 -36 -12 -18 -34q0 -8 -1 -26t-1 -28q0 -226 145 -382t355 -156q72 0 134 18l-70 86q-40 -4 -64 -4zm362 62q138 154 138 376 0 38 -2 56 -2 20 -16 33t-34 13l-4 0q-22 -4 -35 -20t-11 -36q2 -14 2 -46 0 -150 -80 -268 6 -14 20 -51t22 -57z')

                  span Dashboard
              li
                router-link(:to="{ name: 'reservations' }")
                  svg(xlmns='http://www.w3.org/2000/svg' viewBox='-50 -50 1100 1100' preserveAspectRatio='xMinYMin')
                    path(d='M71.4 928.6h785.7V357.1H71.4v571.5zM285.7 250V89.3q0 -7.8 -5 -12.8t-12.8 -5.1h-35.8q-7.8 0 -12.8 5.1t-5 12.8V250q0 7.8 5 12.8t12.8 5.1h35.8q7.8 0 12.8 -5.1t5 -12.8zm428.6 0V89.3q0 -7.8 -5 -12.8t-12.9 -5.1h-35.7q-7.8 0 -12.8 5.1t-5 12.8V250q0 7.8 5 12.8t12.8 5.1h35.7q7.8 0 12.9 -5.1t5 -12.8zm214.3 -35.7v714.3q0 29 -21.2 50.2t-50.3 21.2H71.4q-29 0 -50.2 -21.2T0 928.6V214.3q0 -29 21.2 -50.2t50.2 -21.2h71.5V89.3q0 -36.8 26.2 -63.1T232.1 0h35.8q36.8 0 63 26.2t26.2 63.1v53.6h214.3V89.3q0 -36.8 26.3 -63.1T660.7 0h35.7q36.9 0 63.1 26.2t26.2 63.1v53.6h71.4q29.1 0 50.3 21.2t21.2 50.2z')

                  span Reservations


    ul#short-cuts.list-horizontal
      li.nav-link
        a(@click='search()')
            svg(xlmns='http://www.w3.org/2000/svg' viewBox='-25 200 625 625' preserveAspectRatio='xMinYMin')
              path(d='M550 450q30 0 30 50t-30 50l-210 0l0 210q0 30 -50 30t-50 -30l0 -210l-210 0q-30 0 -30 -50t30 -50l210 0l0 -210q0 -30 50 -30t50 30l0 210l210 0z')
        li.nav-link
          a(@click='create()')
            svg(xlmns='http://www.w3.org/2000/svg' viewBox='-50 40 1000 1000' preserveAspectRatio='xMinYMin')
              path(d='M642.9 464.3q0 -103.3 -73.4 -176.6T392.9 214.3t-176.7 73.4 -73.3 176.6 73.3 176.6 176.7 73.4 176.6 -73.4 73.4 -176.6zm285.7 464.3q0 29 -21.2 50.2t-50.3 21.2q-30.1 0 -50.2 -21.2L615.5 787.9q-99.9 69.2 -222.6 69.2 -79.8 0 -152.7 -30.9T114.7 742.5 31 616.9 0 464.3 31 311.7t83.7 -125.6 125.5 -83.7 152.7 -31 152.6 31T671 186.1t83.7 125.6 31 152.6q0 122.8 -69.2 222.6l191.4 191.4q20.7 20.7 20.7 50.3z')

    content
      router-view

</template>

<style lang='stylus' scoped>
  @import '~Styles/global/colors'
  @import '~Styles/global/layout'


  #gimmecar-app
    max-width: 80rem
    margin: 0 auto

    background: $background-color-app

  header
    float: left
    width: 100%
    padding: $padding-default
    text-align: center

    .logo
      height: 2.8125rem
      display: inline-block
      text-align: center

    small
      display: block

      font-size: 55%
      font-weight: 400

  #navigation,
  #short-cuts
    position: absolute
    top: $padding-default
    height: 2.8125rem

  #navigation
    left: $padding-default

    nav
      position: relative
      z-index: 2
      float: left

      width: 100%
      min-width: 15rem
      max-width: 25rem

      background: #ffffff
      border-radius: 0.25rem
      box-shadow: 0 3.125rem 6.25rem rgba(50, 50, 50, .1), 0 0.5rem 2rem rgba(150, 150, 150, 0.15), 0 0.125rem 1rem rgba(0, 0, 0, .1)

    ul#main-nav
      padding: $padding-sm 0
      float: left
      list-style: none
      text-align: left

      li
        width: 100%

        > a
          padding-left: $padding-default
          float: left

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

          span
            float: left

        > a.active
          color: $text-color-dark-blue

          svg
            fill: $text-color-dark-blue


  #short-cuts
    right: $padding-default
    list-style: none

    .nav-link > a
      margin-left: $padding-default

  .nav-link
    > a
      float: left
      height: 2.8125rem

      float: left
      font-size: 0.8125rem
      font-weight: 700
      line-height: @height

      svg
        height: 1.125rem
        width: 1.125rem
        margin: ((2.8125rem - 1.125rem - 0.0625rem) / 2) 0
        float: left
        fill: #929ea7

      &:hover svg
        fill: $blue

  content
    float: left
    width: 100%
    padding: 0 $padding-default

</style>
