<script>
  import FDate      from 'Filters/date'
  import FTime      from 'Filters/time'
  import Percent    from 'Filters/percent'
  import Capitalize from 'lodash/capitalize'
  import CamelCase  from 'lodash/camelCase'

  import Dropdown from 'Components/dropdown'

  import ActionsIcon from 'Components/icons/actions'
  import RightArrowIcon from 'Components/icons/right_arrow'

  import DriverInfo from 'Components/driver/information'

  import Close from './rental/close'
  import Extend from 'Components/rental/extend'

  export default {
    name: 'Rental',
    data() {
      return {
        rental: {},
        action: '',
        action_url: ''
      }
    },
    filters: {
      date: FDate,
      time: FTime,
      Percent,
      Capitalize,
    },
    components: {
      ActionsIcon,
      Close,
      DriverInfo,
      Dropdown,
      Extend,
      RightArrowIcon,
    },
    created() {
      this.getData()
    },
    watch: {
      '$route': 'getData',
    },
    computed: {
      isClosed() {
        return this.rental.status == "closed"
      },
    },
    methods: {
      getData() {
        this.$http.get(this.$route.path).then(response => {
          this.rental = response.data
        })
      },
      loadAction(action) {
        this.action_url = this.rental.actions[action].url
        this.action = CamelCase(action)
      },
      refreshData() {
        this.getData()
        this.action = ''
      },
      printInvoice() {
        this.$router.push({ name: 'rental_print', params: { number: this.rental.number }})
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
              li(v-if='rental.actions.close')
                button.link(@click='loadAction("close")') Close
              li(v-if='rental.actions.extend')
                button.link(@click='loadAction("extend")') Extend
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

      table.panel-table.thead-bt
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
              template(v-if='isClosed') {{ rental.drop_off_fuel/10 | percent }}
              template(v-else) --
          tr
            td Odometer
            td.text-right {{ rental.pickup_odometer }}
            td.text-right
              template(v-if='isClosed') {{ rental.drop_off_odometer }}
              template(v-else) --

    .panel.panel-base
      h6.left.pt-sm.pl-default Driver
      driver-info.left(:driver='rental.driver')

    .panel.panel-base(v-if='rental.additional_driver')
      h6.left.pt-sm.pl-default Additional Driver
      driver-info.left(:driver='rental.additional_driver')

    component(:is='action'
              :url='action_url'
              @close='refreshData')
</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/table'

  .action-icon
    float: right
    height: 1.25rem

</style>
