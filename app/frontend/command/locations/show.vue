<script>
  import AddressFormat from 'Components/address'
  import RentalsTable from 'Components/rental/table'
  import VehicleTable from 'Components/vehicle/table'
  import MonthlyRevenue from 'Command/vehicles/vehicle/monthly_revenue'
  import MetricsTable from './metrics'

  export default {
    name: 'Location',
    data () {
      return {
        location: {},
        rentals: {},
        vehicles: {},
        revenue: {},
        metrics: {},
        tab: '',
      }
    },
    components: {
      AddressFormat,
      MonthlyRevenue,
      MetricsTable,
      RentalsTable,
      VehicleTable,
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
      viewVehicle (vin) {
        this.$router.push({ name: 'vehicle', params: { vin: vin }})
      },
      tabActive (value) {
        return this.tab === value;
      },
      getData () {
        this.$http.get(this.$route.path).then(response => {
          this.location = response.data
        })
      },
    },
  }
</script>

<template lang='pug'>
  div
    .panel.panel-base
      .panel-base-header
        h2 {{ location.name }}

      table.panel-table.panel-table-key-pair
        tbody
          tr
            td Address
            td
              address-format(:address='location')
          tr
            td Phone #
            td
              a(v-bind:href="'tel:' + location.phone_number") {{ location.phone_number }}

    .sub-navigation
      ul.list-horizontal
        li
          a(@click.prevent='view("rentals")' v-bind:class='{ active: tabActive("rentals") }') Rentals
        li
          a(@click.prevent='view("vehicles")' v-bind:class='{ active: tabActive("vehicles") }') Vehicles
        li
          a(@click.prevent='view("revenue")' v-bind:class='{ active: tabActive("revenue") }') Revenue
        li
          a(@click.prevent='view("metrics")' v-bind:class='{ active: tabActive("metrics") }') Metrics

    rentals-table(
      v-if='tabActive("rentals")'
      :rentals='rentals'
      :show_location='false'
      v-on:view-rental='viewRental($event)'
    )

    vehicle-table(
      v-else-if='tabActive("vehicles")'
      :vehicles='vehicles'
      :show_location='false'
      v-on:view-vehicle='viewVehicle($event)'
    )

    monthly-revenue(
      v-else-if='tabActive("revenue")'
      :revenue='revenue'
    )

    metrics-table(
      v-else-if='tabActive("metrics")'
      :metrics='metrics'
    )
</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/table'
  @import '~Styles/components/panels/sub_navigation'
</style>
