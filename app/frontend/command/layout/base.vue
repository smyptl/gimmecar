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
          small Command

        nav.left
          #navigation
            ul.list-horizontal
              li
                router-link(:to="{ name: 'rentals' }") Rentals
              li
                router-link(:to="{ name: 'vehicles' }") Vehicles
              <!--li-->
                <!--router-link(:to="{ name: 'reports' }") Reports-->

    content
      .gimmecar-app-container#gimmecar-app-command
        router-view

    <!--footer-->

</template>

<style lang='stylus'>
  @import '~Styles/components/layout'
</style>
