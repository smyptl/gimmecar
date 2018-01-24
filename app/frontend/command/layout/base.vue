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
    header.left
      .gimmecar-app-container
        h1.logo.root-link
          | GimmeCar
          small {{ location_name }}


    nav.left
      .gimmecar-app-container
        ul#navigation.list-horizontal
          li
            router-link(:to="{ name: 'rentals' }") Rentals
          li
            router-link(:to="{ name: 'vehicles' }") Vehicles

    content
      router-view

    <!--footer-->

</template>

<style lang='stylus' scoped>
  @import '~Styles/global/colors'
  @import '~Styles/global/layout'

  header
    width: 100%
    display: flex
    padding-bottom: $padding-default
    padding-top: $padding-default

    .gimmecar-app-container
      float: left
      width: 100%
      flex-direction: row
      z-index: 10

  header
  nav
    flex: none
    background: $background-color-header

  nav
    width: 100%
    border-bottom: 2px solid $border-color-light

  #navigation
    float: left

    li:first-of-type
      padding-left: 0

    li
      padding: 0 $padding-sm
      list-style: none

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

  .logo
    flex: 1
    align-self: center
    display: inline-block
    text-align: left

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

  footer
    float: left
    margin: $margin-default 0
    align-self: flex-end

</style>
