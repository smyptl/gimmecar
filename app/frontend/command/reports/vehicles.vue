<script>
  import Currency           from 'Filters/currency'
  import Capitalize         from 'lodash/capitalize'
  import VehicleStatusIcons from 'Components/vehicle/status'

  export default {
    name: 'Vehicles',
    props: {
      vehicles: {
        required: true,
        type: Object,
      },
    },
    filters: {
      Capitalize,
      Currency,
    },
    components: {
      VehicleStatusIcons,
    },
    computed: {
      sorted_vehicles() {
        return this.vehicles.data
      },
    },
    methods: {
      lastFive(vin) {
        return vin.slice(-5)
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
            th License #
            th Fuel Level
            th Odometer
            th Revenue
        tbody
          tr.clickable(
            v-for='vehicle in sorted_vehicles'
            :key='vehicle.id'
            @click.prevent='$emit("view-vehicle", vehicle.vin)'
          )

            td.status
              vehicle-status-icons(:status='vehicle.status')
            td {{ vehicle.make_model }}
            td {{ vehicle.vehicle_type }}
            td
              template(v-if='vehicle.license_number') {{ vehicle.license_number }}
              template(v-else)
                i VIN: {{ lastFive(vehicle.vin) }}
            td {{ vehicle.fuel_level*10 }}%
            td {{ vehicle.odometer }}
            td {{ vehicle.revenue | currency }}

</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/table'
</style>
