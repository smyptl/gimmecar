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
  div
    h2 {{ this.$route.params.number }}

    h5.margin-botton-sm Rental Details
    table.panel-table.panel-table-key-pair.margin-bottom-default
      tbody
        tr
          td Pickup
          td {{ rental.pickup | date_time }}
        tr
          td Drop Off
          td {{ rental.drop_off | date_time }}
        tr
          td Vehicle
          td {{ rental.vehicle.make }} {{ rental.vehicle.model }}
        tr
          td Vehicle License #
          td {{ rental.vehicle.license_number }}

    h5.margin-botton-sm Driver
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
