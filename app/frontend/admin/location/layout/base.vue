<script>
  import Add from './add'

  export default {
    name: 'location',
    data () {
      return {
        nav: false,
        add: false,
      }
    },
    components: {
      Add,
    },
    computed: {
      location_name () {
        return LOCATION_NAME
      },
    },
    methods: {
      toggleNav () {
        this.nav = this.nav === false
      },
      closeNav () {
        this.nav = false
      },
      toggleAdd () {
        this.add = this.add === false
      },
      closeAdd () {
        this.add = false
      },
      search () {
      },
    },
  }
</script>

<template lang='pug'>
  #gimmecar-app
    header
      .gimmecar-app-container
        h1.logo
          | GimmeCar
          small {{ location_name }}


        nav.left
          #navigation
            ul.list-horizontal
              li
                router-link(:to="{ name: 'dashboard' }") Dashboard
              li
                router-link(:to="{ name: 'rentals' }") Rentals
              li
                router-link(:to="{ name: 'rates' }") Rates
              li
                router-link(:to="{ name: 'vehicles' }") Vehicles

          ul#short-cuts.list-horizontal
            li.nav-link#add-link
              a(@click='toggleAdd()')
                svg(xlmns='http://www.w3.org/2000/svg' viewBox='-25 200 625 625' preserveAspectRatio='xMinYMin')
                  path(d='M550 450q30 0 30 50t-30 50l-210 0l0 210q0 30 -50 30t-50 -30l0 -210l-210 0q-30 0 -30 -50t30 -50l210 0l0 -210q0 -30 50 -30t50 30l0 210l210 0z')

              add(v-if='add' @close-add='closeAdd')

          <!--li.nav-link-->
            <!--a(@click='search()')-->
              <!--svg(xlmns='http://www.w3.org/2000/svg' viewBox='-50 40 1000 1000' preserveAspectRatio='xMinYMin')-->
                <!--path(d='M642.9 464.3q0 -103.3 -73.4 -176.6T392.9 214.3t-176.7 73.4 -73.3 176.6 73.3 176.6 176.7 73.4 176.6 -73.4 73.4 -176.6zm285.7 464.3q0 29 -21.2 50.2t-50.3 21.2q-30.1 0 -50.2 -21.2L615.5 787.9q-99.9 69.2 -222.6 69.2 -79.8 0 -152.7 -30.9T114.7 742.5 31 616.9 0 464.3 31 311.7t83.7 -125.6 125.5 -83.7 152.7 -31 152.6 31T671 186.1t83.7 125.6 31 152.6q0 122.8 -69.2 222.6l191.4 191.4q20.7 20.7 20.7 50.3z')-->


    content
      .gimmecar-app-container
        .gimmecar-app-content
          router-view

    <!--footer-->

</template>

<style lang='stylus'>
  @import '~Styles/global/colors'
  @import '~Styles/global/layout'

  header
    background: $background-color-header
    border-bottom: 2px solid $border-color-light

    .gimmecar-app-container
      margin: 0 auto

  .logo
    padding-top: $padding-default
    padding-bottom: $padding-default

    text-align: left


  nav
    width: 100%

    display: flex
    flex-direction: row

  #navigation
    flex: auto
    overflow-x: scroll
    overflow-y: visible

    ul
      width: 1000rem
      list-style: none

    li:first-of-type
      padding-left: 0

    li
      padding: 0 $padding-sm

      a
        float: left
        padding: 0 0 $padding-sm

        line-height: 1.875rem - $padding-sm
        font-size: 0.925rem
        font-weight: 700

      a.active
        color: $black-ex-light
        border-bottom: 0.125rem solid $silver-light
        margin-bottom: -0.125rem

  #short-cuts
    flex: auto
    list-style: none

    .nav-link
      position: relative
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
        height: 1.125rem
        width: 1.125rem
        fill: #9badb6

      &:hover svg
        fill: $purple

  content
    float: left
    width: 100%
    flex-grow: 2
    align-self: auto

    .gimmecar-app-content
      overflow-y: auto

  footer
    float: left
    margin: $margin-default 0
    align-self: flex-end

</style>
