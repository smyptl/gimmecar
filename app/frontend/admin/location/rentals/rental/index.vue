<script>
  import FDate from 'Filters/date'
  import FDateTime from 'Filters/date_time'
  import Capitalize from 'lodash/capitalize'

  import Dropdown from 'Components/dropdown'

  import ActionsIcon from 'Components/icons/actions'
  import RightArrowIcon from 'Components/icons/right_arrow'

  import Close from './_close'

  export default {
    name: 'rental',
    data () {
      return {
        rental: {},
        close: false,
      }
    },
    filters: {
      date: FDate,
      date_time: FDateTime,
      Capitalize,
    },
    components: {
      ActionsIcon,
      Close,
      Dropdown,
      RightArrowIcon,
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
          this.rental = response.data
        })
      },
      extendRental () {
      },
      closeRental () {
        this.close = true
      },
      rentalClosed () {
        this.fetchData()
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
          a(data-toggle='dropdown')
            actions-icon.action-icon
          .dropdown-menu.right(slot='dropdown-menu')
            ul
              li(v-if='rental.status == "open"')
                button.link(@click='closeRental()') Close
              li
                button.link(@click='printInvoice') Print Invoice

      dl.panel-main-details
        dt Status
        dd {{ rental.status | capitalize }}
        dt Pickup
        dd {{ rental.pickup | date_time }}
        dt Drop Off
        dd {{ rental.drop_off | date_time }}
        dt Vehicle
        dd
          span.block {{ rental.vehicle.make }} {{ rental.vehicle.model }}
          span.block.description License #: {{ rental.vehicle.license_number }}

    .panel.panel-base.whole
      h6.padding-top-sm.padding-left-default Driver
      dl.panel-main-details
        dt Name
        dd {{ rental.driver.name_first }} {{ rental.driver.name_middle }} {{ rental.driver.name_last }}
        dt Email
        dd {{ rental.driver.email }}
        dt Cell Phone #
        dd {{ rental.driver.cell_phone_number }}
        template(v-if='rental.driver.home_phone_number')
          dt Home Phone #
          dd {{ rental.driver.home_phone_number }}

    .panel.panel-base.whole(v-if='rental.additional_driver')
      h6.padding-top-sm.padding-left-default Additional Driver
      dl.panel-main-details
        dt Name
        dd {{ rental.additional_driver.name_first }} {{ rental.additional_driver.name_middle }} {{ rental.additional_driver.name_last }}
        dt Email
        dd {{ rental.additional_driver.email }}
        dt Cell Phone #
        dd {{ rental.additional_driver.cell_phone_number }}
        template(v-if='rental.additional_driver.home_phone_number')
          dt Home Phone #
          dd {{ rental.driver.home_phone_number }}

    close(v-on:close='rentalClosed' v-if='close')

</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/details'

  .action-icon
    float: right
    height: 1.25rem

</style>
