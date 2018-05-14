<script>
  import Currency from 'Filters/currency'
  import SnackCase  from 'lodash/snakeCase'

  import Values from 'lodash/values'
  import SumBy from 'lodash/sumBy'

  import Vehicles from 'Components/vehicle/table'

  export default {
    name: 'Reports',
    data() {
      return {
        revenue: {},
        vehicles: {},
        tab: '',
      }
    },
    filters: {
      Currency
    },
    components: {
      Vehicles,
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
    },
  }
</script>

<template lang='pug'>
  div
    .sub-navigation
      ul.list-horizontal
        li
          a(@click.prevent='view("revenue")' :class='{ active: tabActive("revenue") }') Revenue
        li
          a(@click.prevent='view("vehicles")' :class='{ active: tabActive("vehicles") }') Vehicles

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
      template(slot='body' slot-scope='slotProps')
        td {{ slotProps.vehicle.fuel_level*10 }}%
        td {{ slotProps.vehicle.odometer }}
        td {{ slotProps.vehicle.revenue | currency }}

</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/table'
</style>
