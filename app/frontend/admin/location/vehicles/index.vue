<script>
  import X from 'Components/icons/cancel.vue'
  import C from 'Components/icons/check.vue'

  import VehicleStatusIcons from 'Components/vehicles/status'

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
  .gimmecar-app-container
    table.panel-table.margin-top-default
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
  @import '~Styles/global/colors'

  .status
    vertical-align: center
</style>
