<script>
  export default {
    name: 'command',
    data () {
      return {
        nav: false,
        add: false,
      }
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
      .gimmecar-app-container#gimmecar-app-command
        h1.logo
          | GimmeCar
          small {{ location_name }}


        nav.left
          #navigation
            ul.list-horizontal
              li
                router-link(:to="{ name: 'rentals' }") Rentals
              li
                router-link(:to="{ name: 'vehicles' }") Vehicles


    content
      .gimmecar-app-container#gimmecar-app-command
        router-view

    <!--footer-->

</template>

<style lang='stylus' scoped>
@import '~Styles/global/colors'
@import '~Styles/global/layout'

header
  background: $background-color-header
  border-bottom: 2px solid $border-color-light

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
  flex-grow: 2

  .gimmecar-app-vertical-scroll
    overflow-y: auto

footer
  float: left
  margin: $margin-default 0
  align-self: flex-end

</style>
