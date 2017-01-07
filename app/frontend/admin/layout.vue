<script>
  export default {
    name: 'layout',
    mounted () {
      this.$el.focus()
    },
    methods: {
      search () {
        console.log('asdf')
      }
    },
  }
</script>

<template lang='pug'>
  #gimmecar-app
    header
      h1.logo.root-link
        | GimmeCar
        small Super 8 Redlands

      nav
        ul.list-horizontal
          li.nav-link
            router-link.active(to='/') Dashboard

    content
      router-view

</template>

<style lang='stylus' scoped>
  @import '~Styles/global/colors'
  @import '~Styles/global/layout'

  header
    float: left
    width: 100%

    background: $background-color-panel
    border-bottom: 1px solid $border-color-panel

    .logo
      float: left
      display: inline-block

    small
      font-size: 65%
      font-weight: 400
      padding-left: $padding-sm

  .root-link
    padding: $padding-default

  nav
    float: left
    width: 100%
    margin-top: 0.1875rem

    > ul
      padding: 0 $padding-default
      list-style: none

  .nav-link
    > a
      float: left
      padding: 0 $padding-sm
      height: $input-height

      float: left
      font-size: 0.8125rem
      font-weight: 700
      line-height: @height

    .active
      margin-bottom: -1px

      border-left: 0.0625rem solid $border-color-panel
      border-right: 0.0625rem solid $border-color-panel
      background: $background-color-page

      color: #333333

      &::before
        float: left
        content: " "
        width: 100%
        height: 0.1875rem
        margin-top: -0.1875rem
        margin-left: - $padding-sm + -0.0625rem
        margin-right: - $padding-sm + -0.0625rem

        padding: 0 0.6875rem

        background: darken($blue, 2%)
        border-top-left-radius: 0.125rem
        border-top-right-radius: 0.125rem

        box-shadow: 0 0.0625rem 0 0 darken($blue, 10) inset

      &::after
        display: none

  content
    float: left
    height: 100vh
    width: 100%
    padding: $padding-default $padding-default 0

    background: $background-color-page

</style>
