<script>
  import FDate from 'Filters/date'
  import FTime from 'Filters/time'
  import Capitalize from 'lodash/capitalize'

  import Dropdown from 'Components/dropdown'

  import ActionsIcon from 'Components/icons/actions'
  import RightArrowIcon from 'Components/icons/right_arrow'

  import DriverInfo from 'Components/driver/information'

  export default {
    name: 'rental',
    data () {
      return {
        rental: {},
      }
    },
    filters: {
      date: FDate,
      time: FTime,
      Capitalize,
    },
    components: {
      ActionsIcon,
      Dropdown,
      RightArrowIcon,
      DriverInfo,
    },
    created () {
      this.getData()
    },
    watch: {
      '$route': 'getData',
    },
    methods: {
      getData () {
        this.$http.get(this.$route.path).then(response => {
          this.rental = response.data
        })
      },
      extendRental () {
      },
      emailInvoice () {
      },
      printInvoice () {
        window.open(this.$route.path + '/receipt/print')
      },
    },
  }
</script>

<template lang='pug'>
  div
    .panel.panel-base
      .panel-base-header
        h2 {{ rental.number }}
        dropdown.flex-element.right
          a(data-toggle='dropdown')
            actions-icon.action-icon
          .dropdown-menu.right(slot='dropdown-menu')
            ul
              li
                button.link(@click='printInvoice') Print Invoice

      table.panel-table.panel-table-key-pair
        tbody
          tr
            td Status
            td {{ rental.status | capitalize }}
          tr
            td Pickup
            td {{ rental.pickup | time }}
          tr
            td Drop Off
            td {{ rental.drop_off | time }}
          template(v-if="rental.pickup_location_id == rental.drop_off_location_id")
            tr
              td Location
              td {{ rental.pickup_location_name }}
          template(v-else)
            tr
              td Pick Up Location
              td {{ rental.pickup_location_name }}
            tr
              td Drop Off Location
              td {{ rental.drop_off_location_name }}

          tr
            td Vehicle
            td
              router-link.right(:to="{ name: 'vehicle', params: { vin: rental.vehicle.vin } }")
                span.block {{ rental.vehicle.make }} {{ rental.vehicle.model }}
                span.block.description(v-if='rental.vehicle.license_number') License #: {{ rental.vehicle.license_number }}
                span.block.description(v-else) VIN: {{ rental.vehicle.vin }}

    .panel.panel-base
      h6.left.padding-top-sm.padding-left-default Driver
      driver-info(v-bind:driver='rental.driver')

    .panel.panel-base(v-if='rental.additional_driver')
      h6.left.padding-top-sm.padding-left-default Additional Driver
      driver-info(v-bind:driver='rental.additional_driver')

</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/table'

  .action-icon
    float: right
    height: 1.25rem

</style>
