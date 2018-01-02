<script>
  export default {
    name: 'command',
    data () {
      return {
        nav: false,
        add: false,
      }
    },
    components: {
    },
    computed: {
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
      h1.logo.root-link
        | GimmeCar

    content
      router-view

    footer

</template>

<style lang='stylus' scoped>
  @import '~Styles/global/colors'
  @import '~Styles/global/layout'

  #gimmecar-app
    max-width: 87.5rem
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
        fill: $purple

  content
    float: left
    width: 100%
    padding: 0 $padding-default

  footer
    float: left
    margin: $margin-default 0

</style>
