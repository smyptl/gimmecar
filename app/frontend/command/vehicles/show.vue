<script>
  import FDate from 'Filters/date'
  import FDateTime from 'Filters/date_time'
  import Capitalize from 'lodash/capitalize'

  import Dropdown from 'Components/dropdown'

  import ActionsIcon from 'Components/icons/actions'
  import VehicleStatusIcons from 'Components/vehicles/status'

  export default {
    name: 'vehicle',
    data () {
      return {
        vehicle: {},
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
    },
  }
</script>

<template lang='pug'>
  .panel.panel-base
    .panel-base-header
      h2 {{ vehicle.make }} {{ vehicle.model }}
      <!--dropdown.flex-element.right-->
        <!--a(data-toggle='dropdown')-->
          <!--actions-icon.action-icon-->
        <!--.dropdown-menu.right(slot='dropdown-menu')-->
          <!--ul-->
            <!--li-->
              <!--button.link(@click='changeStatus') Change Status-->

    dl.panel-main-details
      .panel-main-detail
        dt Status
        dd
          vehicle-status-icons.right(:status='vehicle.status')
      .panel-main-detail
        dt Type
        dd {{ vehicle.vehicle_type }}
      .panel-main-detail
        dt Location
        dd {{ vehicle.location_name }}
      .panel-main-detail(v-if='vehicle.license_number')
        dt License Number
        dd {{ vehicle.license_number }}
      .panel-main-detail
        dt Vin
        dd {{ vehicle.vin }}
      .panel-main-detail
        dt Year
        dd {{ vehicle.year }}
      .panel-main-detail
        dt Color
        dd {{ vehicle.color | capitalize }}

</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/details'

  .action-icon
    float: right
    height: 1.25rem

</style>
