<script>
  import Currency from 'Filters/currency'
  import FDate from 'Filters/date'
  import SnackCase  from 'lodash/snakeCase'

  import Values from 'lodash/values'
  import SumBy from 'lodash/sumBy'

  import Vehicles from 'Components/vehicle/table'
  import Rentals  from 'Components/rental/table'

  export default {
    name: 'Reports',
    data() {
      return {
        revenue: {},
        vehicles: {},
        deposits: {},
        tab: '',
      }
    },
    filters: {
      Currency,
      date: FDate,
    },
    components: {
      Vehicles,
      Rentals
    },
    created() {
      this.view('revenue')
    },
    watch: {
      '$route': 'view',
    },
    computed: {
      total() {
        return SumBy(Values(this.revenue), v => { return parseInt(v) })
      },
    },
    methods: {
      tabActive(value) {
        return this.tab === value;
      },
      view(tab) {
        this.$http.get(this.$route.path + '/' + tab).then(response => {
          this[SnackCase(tab)] = response.data
          this.tab = tab
        })
      },
      viewVehicle(vin) {
        this.$router.push({ name: 'vehicle', params: { vin: vin }})
      },
      viewRental(number) {
        this.$router.push({ name: 'rental', params: { number: number }})
      },
    },
  }
</script>

<template lang='pug'>
  div
    .sub-navigation
      ul.list-horizontal
        li
          a(href='#' @click.prevent='view("revenue")' :class='{ active: tabActive("revenue") }') Revenue
        li
          a(href='#' @click.prevent='view("vehicles")' :class='{ active: tabActive("vehicles") }') Vehicles
        li
          a(href='#' @click.prevent='view("deposits")' :class='{ active: tabActive("deposits") }') Unreturned Deposits

    .panel.panel-base(v-if='tabActive("revenue")')
      table.panel-table.panel-table-key-pair
        thead
          tr
            th Month
            th Revenue
        tbody
          tr(v-for='(rev, month) in revenue')
            td {{ month }}
            td {{ rev | currency }}
        tfoot
          tr
            td Total
            td {{ total | currency }}

    vehicles(v-if='tabActive("vehicles")'
             :show_location='false'
             @view-vehicle='viewVehicle($event)'
             :vehicles='vehicles')

      template(slot='header')
        th Fuel Level
        th Odometer
        th Revenue
        th Purchase Price
        th Commissioned Date
        th Decommissioned Date
      template(slot='body' slot-scope='slotProps')
        td {{ slotProps.vehicle.fuel_level*10 }}%
        td {{ slotProps.vehicle.odometer }}
        td {{ slotProps.vehicle.revenue | currency }}
        td {{ slotProps.vehicle.purchase_price | currency }}
        td {{ slotProps.vehicle.date_commissioned | date }}
        td {{ slotProps.vehicle.date_decommissioned | date }}

    rentals(v-if='tabActive("deposits")'
            @view-rental='viewRental($event)'
            :rentals='deposits')
</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/table'
</style>
