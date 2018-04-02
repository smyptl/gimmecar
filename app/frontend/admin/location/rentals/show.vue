<script>
  import FDate from 'Filters/date'
  import FTime from 'Filters/time'
  import Capitalize from 'lodash/capitalize'

  import Dropdown from 'Components/dropdown'

  import ActionsIcon from 'Components/icons/actions'
  import RightArrowIcon from 'Components/icons/right_arrow'

  import DriverInfo from 'Components/driver/information'

  import Close from './rental/close'

  export default {
    name: 'Rental',
    data () {
      return {
        rental: {},
        close: false,
      }
    },
    filters: {
      date: FDate,
      time: FTime,
      Capitalize,
    },
    components: {
      ActionsIcon,
      Close,
      DriverInfo,
      Dropdown,
      RightArrowIcon,
    },
    created () {
      this.getData()
    },
    watch: {
      '$route': 'getData',
    },
    computed: {
      is_closed () {
        return this.rental.status == "closed"
      },
    },
    methods: {
      getData () {
        this.$http.get(this.$route.path).then(response => {
          this.rental = response.data
        })
      },
      extendRental () {
      },
      closeRental () {
        this.close = true
      },
      rentalClosed () {
        this.getData()
        this.close = false
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
          a.right(data-toggle='dropdown' href='#')
            actions-icon.action-icon
          .dropdown-menu.right(slot='dropdown-menu')
            ul
              li(v-if='rental.status == "open"')
                button.link(@click='closeRental()') Close
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
          tr
            td Vehicle
            td
              router-link.right(:to="{ name: 'vehicle', params: { vin: rental.vehicle.vin } }")
                span.block {{ rental.vehicle.make_model }}
                span.block.description(v-if='rental.vehicle.license_number') License #: {{ rental.vehicle.license_number }}
                span.block.description(v-else) VIN: {{ rental.vehicle.vin }}
      table.panel-table
        thead
          tr
            th
            th.text-right Pickup
            th.text-right Drop Off
        tbody
          tr
            td Fuel
            td.text-right {{ rental.pickup_fuel/10 | percent }}
            td.text-right
              template(v-if='is_closed') {{ rental.drop_off_fuel/10 | percent }}
              template(v-else) --
          tr
            td Odometer
            td.text-right {{ rental.pickup_odometer }}
            td.text-right
              template(v-if='is_closed') {{ rental.drop_off_odometer }}
              template(v-else) --

    .panel.panel-base
      h6.left.pt-sm.pl-default Driver
      driver-info(v-bind:driver='rental.driver')

    .panel.panel-base(v-if='rental.additional_driver')
      h6.left.pt-sm.pl-default Additional Driver
      driver-info(v-bind:driver='rental.additional_driver')

    close(v-on:close='rentalClosed' v-if='close')
</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/table'

  .action-icon
    float: right
    height: 1.25rem

</style>
