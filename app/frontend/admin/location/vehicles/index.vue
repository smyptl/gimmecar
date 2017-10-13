<script>
  import X from 'Components/icons/cancel.vue'
  import C from 'Components/icons/check.vue'

  import VehicleStatusIcons from 'Components/Vehicles/Status'

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
        tr.clickable(v-for='vehicle in vehicles' @click.prevent='viewVehicle(vehicle.vin)')
          td {{ vehicle.make_model }}
          td {{ vehicle.vehicle_type }}
          td {{ vehicle.license_number }}
          td.status
            vehicle-status-icons(:status='vehicle.status')
</template>

<style lang='stylus' scoped>
  @import '~Styles/global/colors'

  .status
    vertical-align: center
</style>
