<script>
  import FDate from 'Filters/date'
  import FTime from 'Filters/time'
  import Capitalize from 'lodash/capitalize'
  import Camelcase from 'lodash/camelCase'

  import Dropdown from 'Components/dropdown'

  import ActionsIcon from 'Components/icons/actions'
  import RightArrowIcon from 'Components/icons/right_arrow'

  import DriverInfo from 'Components/driver/information'
  import Extend from './rental/extend'
  import ReturnDeposit from './rental/return_deposit'


  export default {
    name: 'Rental',
    data () {
      return {
        rental: {},
        action: '',
        action_url: ''
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
      DriverInfo,
      Extend,
      ReturnDeposit,
      RightArrowIcon,
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
      loadAction (action) {
        this.action_url = this.rental.actions[action].url
        this.action = Camelcase(action)
      },
      refreshData () {
        this.getData()
        this.action = ''
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
          a.right(href='#' data-toggle='dropdown')
            actions-icon.action-icon
          .dropdown-menu.right(slot='dropdown-menu')
            ul
              li
                button.link(@click='printInvoice') Print Invoice
              li(v-if='rental.actions.extend')
                button.link(@click='loadAction("extend")') Extend Rental
              li(v-if='rental.actions.return_deposit')
                button.link(@click='loadAction("return_deposit")') Return Deposit

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
                span.block {{ rental.vehicle.make_model }}
                span.block.description(v-if='rental.vehicle.license_number') License #: {{ rental.vehicle.license_number }}
                span.block.description(v-else) VIN: {{ rental.vehicle.vin }}

          tr
            td Driver
            td
              router-link.right(:to="{ name: 'driver', params: { id: rental.driver.id } }")
                span.block {{ rental.driver.name }}

          tr(v-if='rental.additional_driver')
            td Additional Driver
            td
              router-link.right(:to="{ name: 'driver', params: { id: rental.additional_driver.id } }")
                span.block {{ rental.additional_driver.name }}

    component(:is='action' :url='action_url' v-on:close='refreshData')

</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/table'

  .action-icon
    float: right
    height: 1.25rem

</style>
