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
              LOCATION = this.locations[0]
              this.$router.push({ name: 'dashboard', params: { location: LOCATION.slug } })
            }
          })
          .catch(response => {
            this.$router.push({ name: 'login' })
          })
      },
    },
  }
</script>

<template lang='pug'>
</template>

<style lang='stylus' scoped>
  #locations-container
    width: 20rem
    margin: 0 auto 5rem
    align-self: center

    padding: 0 $padding-default
</style>
