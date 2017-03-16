<script>
  import FDateTime from 'Filters/date_time'

  export default {
    name: 'index',
    data () {
      return {
        rentals: [],
      }
    },
    filters: {
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
            this.rentals = response.data
        })
      },
      viewRental (number) {
        this.$router.push({ name: 'rental', params: { number: number }})
      },
    },
  }
</script>

<template lang='pug'>
  .panel.panel-base
    table.panel-table
      thead
        tr
          th #
          th Name
          th Vehicle
          th Pickup
          th Drop Off
      tbody.alternate-color
        tr.clickable(v-for='rental in rentals' @click.prevent='viewRental(rental.number)')
          td {{ rental.number }}
          td {{ rental.name }}
          td {{ rental.vehicle }}
          td {{ rental.pickup | date_time }}
          td {{ rental.drop_off | date_time }}
</template>
