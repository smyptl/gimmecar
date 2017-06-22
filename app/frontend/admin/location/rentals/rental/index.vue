<script>
  import FDate from 'Filters/date'
  import FDateTime from 'Filters/date_time'
  import Capitalize from 'lodash/capitalize'

  import Dropdown from 'Components/dropdown'

  import ActionsIcon from 'Components/icons/actions'
  import RightArrowIcon from 'Components/icons/right_arrow'

  import Close from './close'

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
  .panel.panel-base
    close(v-on:close='rentalClosed' v-if='close')
    .panel-base-header
      h2 {{ rental.number }}
      dropdown.flex-element.right
        a(data-toggle='dropdown')
          actions-icon.action-icon
        .dropdown-menu.right(slot='dropdown-menu')
          ul
            li
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

      a.panel-details-link(href='####')
        dt Driver
        dd {{ rental.driver.first_name }} {{ rental.driver.last_name }}
        right-arrow-icon
      a.panel-details-link(href='####')
        dt Vehicle
        dd
          span.block {{ rental.vehicle.make }} {{ rental.vehicle.model }}
          span.block.description License #: {{ rental.vehicle.license_number }}
        right-arrow-icon

</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/details'

  .action-icon
    float: right
    height: 1.25rem

</style>
