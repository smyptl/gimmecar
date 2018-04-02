<script>
  export default {
    name: 'Locations',
    data () {
      return {
        locations: {},
      }
    },
    created () {
      this.getData()
    },
    watch: {
      '$route': 'getData',
    },
    computed: {
      sorted_locations () {
        return this.locations.data
      },
    },
    methods: {
      getData () {
        this.$http
          .get(this.$route.path)
          .then(response => {
            this.locations = response.data
        })
      },
      viewLocation (slug) {
        this.$router.push({ name: 'location', params: { slug: slug }})
      },
    },
  }
</script>

<template lang='pug'>
  .panel.panel-base
    .gimmecar-app-vertical-scroll
      table.panel-table
        thead
          tr
            th Location
            th Address
            th Phone #
        tbody
          tr.clickable(v-for='location in sorted_locations')
            td {{ location.name }}
            td
              span.block {{ location.address_1 }} {{ location.address_2 }}
              span.block {{ location.city }}, {{ location.state }} {{ location.zip_code }}
            td.text-nowrap
              a(v-bind:href="'tel:' + location.phone_number") {{ location.phone_number }}
</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/table'
</style>
