<script>
  import FDate from "Filters/date"
  import FDateTime from "Filters/date_time"

  export default {
    name: 'rental',
    data () {
      return {
        rental: {},
      }
    },
    filters: {
      date: FDate,
      date_time: FDateTime,
    },
    created () {
      this.fetchData()
    },
    watch: {
      '$route': 'fetchData',
    },
    methods: {
      fetchData () {
        this.$http
          .get(this.$route.path)
          .then(response => {
            this.rental = response.data
        })
      },
    },
  }
</script>

<template lang='pug'>
  .panel.panel-base
    h2.margin-bottom-default.panel-padding {{ rental.number }}

    dl.panel-main-details
      dt Status
      dd {{ rental.status }}
      dt Pickup
      dd {{ rental.pickup | date_time }}
      dt Drop Off
      dd {{ rental.drop_off | date_time }}
      dt Vehicle
      dd {{ rental.vehicle.make }} {{ rental.vehicle.model }}
      dt Vehicle License #
      dd {{ rental.vehicle.license_number }}

    .panel-padding.left
      h5.margin-botton-sm Driver
      .panel
        table.panel-table.panel-table-key-pair
          tbody
            tr
              td Name
              td {{ rental.driver.first_name }} {{ rental.driver.last_name }}
            tr
              td License #
              td {{ rental.driver.license_number }}
            tr
              td Address
              td
                span.block {{ rental.driver.address_1 }}
                span.block(v-if='rental.driver.address_2') {{ rental.driver.address_2 }}
                span.block {{ rental.driver.city }}, {{ rental.driver.state }} {{ rental.driver.zip_code }}
                span.block {{ rental.driver.country }}
            tr
              td Email
              td {{ rental.driver.email }}
            tr
              td Home Phone #
              td {{ rental.driver.home_phone_number }}
            tr
              td Cell Phone #
              td {{ rental.driver.cell_phone_number }}

</template>

<style lang='stylus' scoped>
</style>
