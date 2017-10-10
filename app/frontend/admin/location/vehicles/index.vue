<script>
  import X from 'Components/icons/cancel.vue'
  import C from 'Components/icons/check.vue'

  export default {
    name: 'index',
    data () {
      return {
        vehicles: [],
      }
    },
    created () {
      this.fetchData()
    },
    components: {
      X,
      C,
    },
    watch: {
      '$route': 'fetchData',
    },
    methods: {
      fetchData () {
        this.$http
          .get(this.$route.path)
          .then(response => {
            this.vehicles = response.data
        })
      },
      viewVehicle (vin) {
        this.$router.push({ name: 'vehicle', params: { vin: vin }})
      },
    },
  }
</script>

<template lang='pug'>
  .panel.panel-base.whole
    table.panel-table
      thead
        tr
          th Vehicle
          th Type
          th License #
          th Status
      tbody.alternate-color
        tr(v-for='vehicle in vehicles' @click.prevent='viewVehicle(vehicle.vin)')
          td {{ vehicle.make_model }}
          td {{ vehicle.vehicle_type }}
          td {{ vehicle.license_number }}
          td.status
            svg#service(v-if='vehicle.status == "service"' xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round")
              polyline(points="22 12 18 12 15 21 9 3 6 12 2 12")
            svg#rented(v-if='vehicle.status == "rented"' xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round")
              polyline(points="3 11 22 2 13 21 11 13 3 11")
            svg#clean(v-if='vehicle.status == "clean"' xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round")
              path(d="M22 11.07V12a10 10 0 1 1-5.93-9.14")
              polyline(points="23 3 12 14 9 11")
            svg#dirty(v-if='vehicle.status == "dirty"' xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round")
              circle(cx="12" cy="12" r="10")
              line(x1="12" y1="8" x2="12" y2="12")
              line(x1="12" y1="16" x2="12" y2="16")
</template>

<style lang='stylus' scoped>
  @import '~Styles/global/colors'

  .status
    vertical-align: center

  td
    svg
      float: left
      fill: none

      height: 1rem
      width: 1rem
      color: $blue-dark

    svg#service
      color: $text-color-yellow

    svg#clean
      color: $text-color-green

    svg#dirty
      color: $text-color-red

</style>
