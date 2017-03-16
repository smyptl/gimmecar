<script>
  import Navigation from './nav'
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
      Navigation,
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
      #navigation.nav-link
        a(@click='toggleNav()')
          svg(xlmns='http://www.w3.org/2000/svg' viewBox='70 35 950 950' preserveAspectRatio='xMinYMin')
            path(d='M67.832 788.208q0 29.768 21.472 50.996t50.752 21.228h793q29.768 0 50.752 -21.228t20.984 -50.996 -20.984 -50.752 -50.752 -20.984h-793q-29.28 0 -50.752 20.984t-21.472 50.752zm0 -287.92q0 29.768 21.472 50.752t50.752 20.984h793q29.768 0 50.752 -20.984t20.984 -50.752 -20.984 -50.996 -50.752 -21.228h-793q-29.28 0 -50.752 21.228t-21.472 50.996zm0 -288.408q0 29.768 21.472 50.752t50.752 20.984h793q29.768 0 50.752 -20.984t20.984 -50.752 -20.984 -50.996 -50.752 -21.228h-793q-29.28 0 -50.752 21.228t-21.472 50.996z')

        navigation(v-if='nav' @close-nav='closeNav')

      h1.logo.root-link
        | GimmeCar
        small {{ location_name }}

      ul#short-cuts.list-horizontal
        li.nav-link#add-link
          a(@click='toggleAdd()')
            svg(xlmns='http://www.w3.org/2000/svg' viewBox='-25 200 625 625' preserveAspectRatio='xMinYMin')
              path(d='M550 450q30 0 30 50t-30 50l-210 0l0 210q0 30 -50 30t-50 -30l0 -210l-210 0q-30 0 -30 -50t30 -50l210 0l0 -210q0 -30 50 -30t50 30l0 210l210 0z')

          add(v-if='add' @close-add='closeAdd')

        li.nav-link
          a(@click='search()')
            svg(xlmns='http://www.w3.org/2000/svg' viewBox='-50 40 1000 1000' preserveAspectRatio='xMinYMin')
              path(d='M642.9 464.3q0 -103.3 -73.4 -176.6T392.9 214.3t-176.7 73.4 -73.3 176.6 73.3 176.6 176.7 73.4 176.6 -73.4 73.4 -176.6zm285.7 464.3q0 29 -21.2 50.2t-50.3 21.2q-30.1 0 -50.2 -21.2L615.5 787.9q-99.9 69.2 -222.6 69.2 -79.8 0 -152.7 -30.9T114.7 742.5 31 616.9 0 464.3 31 311.7t83.7 -125.6 125.5 -83.7 152.7 -31 152.6 31T671 186.1t83.7 125.6 31 152.6q0 122.8 -69.2 222.6l191.4 191.4q20.7 20.7 20.7 50.3z')


    content
      router-view

    footer

</template>

<style lang='stylus' scoped>
  @import '~Styles/global/colors'
  @import '~Styles/global/layout'

  #gimmecar-app
    max-width: 48rem
    margin: 0 auto

  header
    float: left
    width: 100%
    display: flex
    flex-direction: row
    padding: $padding-default
    z-index: 10

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
        height: 1.25rem
        width: 1.25rem
        fill: #9badb6

      &:hover svg
        fill: $blue

  content
    float: left
    width: 100%
    padding: 0 $padding-default

  footer
    float: left
    margin: $margin-default 0

</style>
