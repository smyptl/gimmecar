<script>
  import Snabbt from 'snabbt.js'

  import isUndefined from 'lodash/isUndefined'

  import Navigation from './nav'

  export default {
    name: 'location',
    data () {
      return {
        nav: false,
      }
    },
    components: {
      Navigation,
    },
    computed: {
      location () {
        return { name: 'TEST' }
      }
    },
    methods: {
      openNav () {
        this.nav = true
      },
      closeNav () {
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
      create () {
      },
      search () {
      },
    },
  }
</script>

<template lang='pug'>
  #gimmecar-app
    header
      #navigation.nav-link
        a(@click='closeNav()' v-if='nav')
          svg(xlmns='http://www.w3.org/2000/svg' viewBox='-100 160 675 675' preserveAspectRatio='xMinYMin')
            path(d='M452 656q18 18 18 43t-18 43q-18 16 -43 16t-43 -16l-132 -152 -132 152q-18 16 -43 16t-43 -16q-16 -18 -16 -43t16 -43l138 -156 -138 -158q-16 -18 -16 -43t16 -43q18 -16 43 -16t43 16l132 152 132 -152q18 -16 43 -16t43 16q18 18 18 43t-18 43l-138 158z')


        a(@click='openNav()' v-else)
          svg(xlmns='http://www.w3.org/2000/svg' viewBox='70 35 950 950' preserveAspectRatio='xMinYMin')
            path(d='M67.832 788.208q0 29.768 21.472 50.996t50.752 21.228h793q29.768 0 50.752 -21.228t20.984 -50.996 -20.984 -50.752 -50.752 -20.984h-793q-29.28 0 -50.752 20.984t-21.472 50.752zm0 -287.92q0 29.768 21.472 50.752t50.752 20.984h793q29.768 0 50.752 -20.984t20.984 -50.752 -20.984 -50.996 -50.752 -21.228h-793q-29.28 0 -50.752 21.228t-21.472 50.996zm0 -288.408q0 29.768 21.472 50.752t50.752 20.984h793q29.768 0 50.752 -20.984t20.984 -50.752 -20.984 -50.996 -50.752 -21.228h-793q-29.28 0 -50.752 21.228t-21.472 50.996z')

        navigation(v-if='nav' @close-nav='closeNav')

      h1.logo.root-link
        | GimmeCar
        small {{ location.name }}

      ul#short-cuts.list-horizontal
        li.nav-link
          a(@click='search()')
            svg(xlmns='http://www.w3.org/2000/svg' viewBox='-50 40 1000 1000' preserveAspectRatio='xMinYMin')
              path(d='M642.9 464.3q0 -103.3 -73.4 -176.6T392.9 214.3t-176.7 73.4 -73.3 176.6 73.3 176.6 176.7 73.4 176.6 -73.4 73.4 -176.6zm285.7 464.3q0 29 -21.2 50.2t-50.3 21.2q-30.1 0 -50.2 -21.2L615.5 787.9q-99.9 69.2 -222.6 69.2 -79.8 0 -152.7 -30.9T114.7 742.5 31 616.9 0 464.3 31 311.7t83.7 -125.6 125.5 -83.7 152.7 -31 152.6 31T671 186.1t83.7 125.6 31 152.6q0 122.8 -69.2 222.6l191.4 191.4q20.7 20.7 20.7 50.3z')

        li.nav-link
          router-link(:to="{ name: 'quotes' }")
            svg(xlmns='http://www.w3.org/2000/svg' viewBox='-25 200 625 625' preserveAspectRatio='xMinYMin')
              path(d='M550 450q30 0 30 50t-30 50l-210 0l0 210q0 30 -50 30t-50 -30l0 -210l-210 0q-30 0 -30 -50t30 -50l210 0l0 -210q0 -30 50 -30t50 30l0 210l210 0z')

    content
      router-view

</template>

<style lang='stylus' scoped>
  @import '~Styles/global/colors'
  @import '~Styles/global/layout'

  #gimmecar-app
    max-width: 80rem
    margin: 0 auto

  header
    float: left
    width: 100%
    display: flex
    flex-direction: row
    padding: $padding-default

    text-align: center

  .logo,
  #navigation,
  #short-cuts
    flex: 1
    align-self: center

  .logo
    display: inline-block
    text-align: center

  #navigation
    float: left

  #short-cuts
    list-style: none

    li
      float: right

    .nav-link > a
      margin-left: $padding-default

  .nav-link
    > a
      float: left
      font-size: 0.8125rem
      font-weight: 700

      svg
        float: left
        height: 1.25rem
        width: 1.25rem
        fill: #929ea7

      &:hover svg
        fill: $blue

  content
    float: left
    width: 100%
    padding: 0 $padding-default

</style>
