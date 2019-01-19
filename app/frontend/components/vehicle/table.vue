<script>
  import Capitalize         from 'lodash/capitalize'
  import VehicleStatusIcons from 'Components/vehicle/status'

  export default {
    name: 'Vehicles-Table',
    props: {
      vehicles: {
        required: true,
        type: Object,
      },
      show_location: {
        required: false,
        type: Boolean,
        default: true,
      },
    },
    filters: {
      Capitalize,
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
            th(v-if='show_location') Location
            th License #
            slot(name='header')
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
            td(v-if='show_location') {{ vehicle.location_name }}
            td
              template(v-if='vehicle.license_number')
                .block
                  | {{ vehicle.license_number }}
                  i.text-light.font-mono &nbsp;({{ lastFive(vehicle.vin) }})
              template(v-else)
                i VIN: {{ lastFive(vehicle.vin) }}
            slot(name='body' :vehicle='vehicle')
</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/table'
</style>
