<script>
  import FDate from 'Filters/date'
  import FTime from 'Filters/time'
  import Percent from 'Filters/percent'
  import Currency from 'Filters/currency'
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
        loading: true,
        action: '',
        action_url: ''
      }
    },
    filters: {
      date: FDate,
      time: FTime,
      Capitalize,
      Currency,
      Percent,
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
    computed: {
      is_closed () {
        return this.rental.status == "closed"
      },
    },
    methods: {
      getData () {
        this.$http.get(this.$route.path).then(response => {
          this.rental = response.data
          this.loading = false
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
  div(v-if='!loading')
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
              td
                router-link.right(:to="{ name: 'location', params: { slug: rental.pickup_location_slug } }") {{ rental.pickup_location_name }}
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

      table.panel-table.panel-table-key-pair
        thead
          tr
            th(colspan='2') Metrics
        tbody
          tr
            td Revenue
            td {{ rental.sub_total | currency }}
          tr
            td Avg. Rate
            td {{ rental.average_rate | currency }}
          template(v-if='is_closed')
            tr
              td Miles Driven
              td {{ rental.miles_driven }}
            tr
              td Avg. Price / Mile
              td {{ rental.average_price_per_mile | currency }}

    component(:is='action' :url='action_url' v-on:close='refreshData')

</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/table'

  .action-icon
    float: right
    height: 1.25rem

</style>
