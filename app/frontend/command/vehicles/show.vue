<script>
  import Moment from 'moment'

  import Dropdown from 'Components/dropdown'
  import ActionsIcon from 'Components/icons/actions'
  import VehicleInformation from 'Components/vehicle/information'
  import MonthlyRevenue from 'Command/vehicles/vehicle/monthly_revenue'

  import Percent from 'Filters/percent'

  export default {
    name: 'Vehicle',
    data () {
      return {
        vehicle: {},
        rentals: {},
        revenue: {},
        tab: '',
      }
    },
    components: {
      ActionsIcon,
      Dropdown,
      MonthlyRevenue,
      VehicleInformation,
    },
    filters: {
      Percent,
      time (val) {
        var val = Moment(val)

        if (val.isValid()) {
          return val.format('M/D/YY @ h:mm A')
        }
      },
    },
    created () {
      this.getData()
    },
    watch: {
      '$route': 'getData',
    },
    methods: {
      view (tab) {
        this.$http.get(this.$route.path + '/' + tab).then(response => {
          this[tab] = response.data
          this.tab = tab
        })
      },
      viewRental (number) {
        this.$router.push({ name: 'rental', params: { number: number }})
      },
      tabActive (value) {
        return this.tab === value;
      },
      getData () {
        this.$http.get(this.$route.path).then(response => {
          this.vehicle = response.data
        })
      },
    },
  }
</script>

<template lang='pug'>
  div
    .panel.panel-base
      .panel-base-header
        h2 {{ vehicle.make }} {{ vehicle.model }}

      vehicle-information(v-bind:vehicle='vehicle')
        tr
          td Odometer
          td {{ vehicle.odometer }}
        tr
          td Fuel
          td {{ vehicle.fuel_level/10 | percent }}


    .sub-navigation
      ul.list-horizontal
        li
          a(@click.prevent='view("rentals")' v-bind:class='{ active: tabActive("rentals") }') Rentals
        li
          a(@click.prevent='view("revenue")' v-bind:class='{ active: tabActive("revenue") }') Revenue

    .panel.panel-base(v-if='tabActive("rentals")')
      .gimmecar-app-vertical-scroll
        table.panel-table
          thead
            tr
              th #
              th Name
              th Location
              th Pickup
              th Drop Off
          tbody
            tr.clickable(
              v-for='rental in rentals.data'
              :key='rental.id'
              @click.prevent='viewRental(rental.number)'
            )

              td {{ rental.number }}
              td {{ rental.driver_name }}
              td {{ rental.pickup_location_name }}
              td {{ rental.pickup | time }}
              td {{ rental.drop_off | time }}

    monthly-revenue(v-if='tabActive("revenue")' :revenue='revenue')
</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/table'
  @import '~Styles/components/panels/sub_navigation'
</style>
