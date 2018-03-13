<script>
  export default {
    name: 'drivers',
    data () {
      return {
        drivers: {},
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
            this.drivers = response.data
        })
      },
      viewDriver (id) {
        this.$router.push({ name: 'driver', params: { id: id } })
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
            th Rentals
            th Do Not Rent
        tbody
          tr.clickable(
            v-for='driver in sorted_drivers'
            :key='driver.id'
            @click.prevent='viewDriver(driver.id)'
          )

            td {{ driver.name_full }}
            td {{ driver.rentals_count }}
            td {{ driver.do_not_rent }}
</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/table'
</style>
