<script>
  export default {
    name: 'drivers',
    data () {
      return {
        drivers: [],
      }
    },
    created () {
      this.getData()
    },
    watch: {
      '$route': 'getData',
    },
    computed: {
      sorted_drivers () {
        return this.drivers.data
      },
    },
    methods: {
      getData () {
        this.$http
          .get(this.$route.path)
          .then(response => {
            this.data = response.data
        })
      },
    },
  }
</script>

<template lang='pug'>
  .panel.panel-base
    .gimmecar-app-vertical-scroll
      table.panel-table
        thead
          tr
            th Name
            th Type
            th Location
            th License #
            th Status
        tbody
          tr.clickable(
            v-for='driver in data'
            :key='driver.id'
            @click.prevent='viewDriver(driver.id)'
          )

            td {{ vehicle.make_model }}
            td {{ vehicle.vehicle_type }}
            td {{ vehicle.location_name }}
            td(v-if='vehicle.license_number') {{ vehicle.license_number }}
            td(v-else)
              i VIN: {{ lastFive(vehicle.vin) }}
            td.status
              vehicle-status-icons(:status='vehicle.status')
</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/table'

  .status
    vertical-align: center
</style>
