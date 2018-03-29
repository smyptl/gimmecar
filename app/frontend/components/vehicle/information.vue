<script>
  import Capitalize from 'lodash/capitalize'

  import VehicleStatusIcons from './status'

  export default {
    name: 'Information',
    props: {
      vehicle: {
        required: true,
        type: Object,
      },
    },
    filters: {
      Capitalize,
    },
    components: {
      VehicleStatusIcons,
    },
  }
</script>

<template lang='pug'>
  table.panel-table.panel-table-key-pair
    tbody
      tr
        td Status
        td
          vehicle-status-icons.right(:status='vehicle.status')
      tr
        td Type
        td {{ vehicle.vehicle_type }}
      tr(v-if='vehicle.location_name')
        td Location
        td {{ vehicle.location_name }}
      tr(v-if='vehicle.license_number')
        td License Number
        td {{ vehicle.license_number }}
      tr
        td Vin
        td {{ vehicle.vin }}
      tr
        td Year
        td {{ vehicle.year }}
      tr
        td Color
        td {{ vehicle.color | capitalize }}
      slot

</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/table'

</style>
