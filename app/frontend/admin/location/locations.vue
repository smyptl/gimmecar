<script>
  export default {
    name: 'locations',
    data () {
      return {
        loading: false,
        locations: [],
      }
    },
    created () {
      this.fetchData()
    },
    watch: {
      '$route': 'fetchData',
    },
    methods: {
      fetchData() {
        this.$http.get(this.$route.path)
          .then(response => {
            this.locations = response.data

            if (this.locations.length == 1) {
              this.selectLocation(this.locations[0])
            }
          })
          .catch(response => {
            this.$router.push({ name: 'login' })
          })
      },
      selectLocation (location) {
        LOCATION_NAME = location.name
        this.$router.push({ name: 'dashboard', params: { location: location.slug } })
      },
    },
  }
</script>

<template lang='pug'>
  .flex-container
    #custom
      h4.margin-bottom-default Locations
      .panel.panel-base
        ul.list-no-style
          li(v-for='location in locations')
            a(@click='selectLocation(location)') {{ location.name }}

</template>

<style lang='stylus' scoped>
  @import '~Styles/global/colors'

  #custom
    width: 25rem
    margin: 3rem 0
    float: none

  .flex-container
    height: 100%
    width: 100%
    padding: 2rem

    display: flex
    align-items: center
    justify-content: center

    *
      width: 100%
      float: left

  li
    font-size: 1.25rem
    border-bottom: 0.125rem solid $border-color-light

  li:last-of-type
    border-bottom: 0rem

  a
    padding: 1rem


</style>
