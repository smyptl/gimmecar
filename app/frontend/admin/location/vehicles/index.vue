<script>
  import VehicleStatusIcons from 'Components/vehicles/status'

  export default {
    name: 'vehicles',
    data () {
      return {
        vehicles: [],
      }
    },
    created () {
      this.fetchData()
    },
    components: {
      VehicleStatusIcons,
    },
    watch: {
      '$route': 'fetchData',
    },
    methods: {
      lastFive (vin) {
        return vin.slice(-5)
      },
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
  .panel.panel-base
    .gimmecar-app-vertical-scroll
      table.panel-table
        thead
          tr
            th Vehicle
            th Type
            th License #
            th Status
        tbody
          tr.clickable(v-for='vehicle in vehicles' @click.prevent='viewVehicle(vehicle.vin)')
            td {{ vehicle.make_model }}
            td {{ vehicle.vehicle_type }}
            td(v-if='vehicle.license_number') {{ vehicle.license_number }}
            td(v-else)
              i VIN: {{ lastFive(vehicle.vin) }}
            td.status
              vehicle-status-icons(:status='vehicle.status')
</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/table'

  .status
    vertical-align: center
</style>
