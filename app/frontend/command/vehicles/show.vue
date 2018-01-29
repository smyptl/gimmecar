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

    table.panel-table.panel-table-key-pair
      tbody
      tr
        td Status
        td
          vehicle-status-icons.right(:status='vehicle.status')
      tr
        td Type
        td {{ vehicle.vehicle_type }}
      tr
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

</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/table'

  .action-icon
    float: right
    height: 1.25rem

</style>
