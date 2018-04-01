<script>
  import VehicleStatusIcons from 'Components/vehicle/status'

  export default {
    name: 'Vehicles',
    data () {
      return {
        vehicles: [],
      }
    },
    created () {
      this.getData()
    },
    watch: {
      '$route': 'getData',
    },
    components: {
      VehicleStatusIcons,
    },
    computed: {
      sorted_vehicles () {
        return this.vehicles.data
      },
    },
    methods: {
      lastFive (vin) {
        return vin.slice(-5)
      },
      getData () {
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
            th
            th Vehicle
            th Type
            th Location
            th License #
        tbody
          tr.clickable(v-for='vehicle in sorted_vehicles' @click.prevent='viewVehicle(vehicle.vin)')
            td
              vehicle-status-icons(:status='vehicle.status')
            td {{ vehicle.make_model }}
            td {{ vehicle.vehicle_type }}
            td {{ vehicle.location_name }}
            td
              template(v-if='vehicle.license_number') {{ vehicle.license_number }}
              template(v-else)
                i VIN: {{ lastFive(vehicle.vin) }}
</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/table'
</style>
