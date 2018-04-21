<script>
  import Moment from 'moment'

  import SortBy from 'lodash/sortBy'

  export default {
    name: 'Rentals-Table',
    props: {
      rentals: {
        required: true,
        type: Object,
      },
      show_driver: {
        required: false,
        type: Boolean,
        default: true,
      },
      show_location: {
        required: false,
        type: Boolean,
        default: true,
      },
      show_vehicle: {
        required: false,
        type: Boolean,
        default: true,
      },
    },
    filters: {
      time(val) {
        var val = Moment(val)

        if (val.isValid()) {
          return val.format('M/D @ h:mm A')
        }
      },
    },
    computed: {
      sorted_rentals() {
        return SortBy(this.rentals.data, ['pickup'])
      }
    },
  }
</script>

<template lang='pug'>
  .panel.panel-base
    .gimmecar-app-vertical-scroll
      table.panel-table
        thead
          tr
            th #
            th(v-if='show_driver') Name
            th(v-if='show_location') Location
            th(v-if='show_vehicle') Vehicle
            th Pickup
            th Drop Off
        tbody
          tr.clickable(
            v-for='rental in sorted_rentals'
            :key='rental.id'
            @click.prevent='$emit("view-rental", rental.number)'
          )

            td {{ rental.number }}
            td(v-if='show_driver') {{ rental.driver_name }}
            td(v-if='show_location') {{ rental.pickup_location_name }}
            td(v-if='show_vehicle') {{ rental.vehicle_make_model }}
            td {{ rental.pickup | time }}
            td {{ rental.drop_off | time }}
</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/table'
</style>
