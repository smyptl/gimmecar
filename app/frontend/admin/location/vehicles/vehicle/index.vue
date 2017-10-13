<script>
  import FDate from 'Filters/date'
  import FDateTime from 'Filters/date_time'
  import Capitalize from 'lodash/capitalize'

  import Dropdown from 'Components/dropdown'

  import ActionsIcon from 'Components/icons/actions'
  import VehicleStatusIcons from 'Components/Vehicles/Status'

  import VehicleStatus from './_status'

  export default {
    name: 'vehicle',
    data () {
      return {
        vehicle: {},
        change_status: false,
      }
    },
    filters: {
      date: FDate,
      date_time: FDateTime,
      Capitalize,
    },
    components: {
      ActionsIcon,
      Dropdown,
      VehicleStatus,
      VehicleStatusIcons,
    },
    created () {
      this.fetchData()
    },
    watch: {
      '$route': 'fetchData',
    },
    methods: {
      fetchData () {
        this.$http.get(this.$route.path).then(response => {
          this.vehicle = response.data
        })
      },
      statusChanged () {
        this.fetchData()
        this.change_status = false
      },
      changeStatus () {
        this.change_status = true
      },
    },
  }
</script>

<template lang='pug'>
  div
    .panel.panel-base
      .panel-base-header
        h2 {{ vehicle.make }} {{ vehicle.model }}
        dropdown.flex-element.right
          a(data-toggle='dropdown')
            actions-icon.action-icon
          .dropdown-menu.right(slot='dropdown-menu')
            ul
              li
                button.link(@click='changeStatus') Change Status

      dl.panel-main-details
        dt Status
        dd
          vehicle-status-icons(:status='vehicle.status')
        dt Type
        dd {{ vehicle.vehicle_type }}
        template(v-if='vehicle.license_number')
          dt License Number
          dd {{ vehicle.license_number }}
        dt Vin
        dd {{ vehicle.vin }}
        dt Year
        dd {{ vehicle.year }}
        dt Color
        dd {{ vehicle.color | capitalize }}

    vehicle-status(v-on:close='statusChanged' v-if='change_status')

</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/details'

  .action-icon
    float: right
    height: 1.25rem

</style>
