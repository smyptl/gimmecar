<script>
  import Moment from 'moment'

  import SortBy from 'lodash/sortBy'

  export default {
    name: 'index',
    data () {
      return {
        rentals: [],
      }
    },
    filters: {
      date_time (val) {
        var val = Moment(val)

        if (val.isValid()) {
          return val.format('M/D @ h:mm A')
        }
      },
    },
    created () {
      this.fetchData()
    },
    watch: {
      '$route': 'fetchData',
    },
    computed: {
      sorted_rentals () {
        return SortBy(this.rentals, ['pickup'])
      }
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
  .gimmecar-app-vertical-scroll
    table.panel-table.margin-top-default
      thead
        tr
          th #
          th Name
          th Location
          th Vehicle
          th Pickup
          th Drop Off
      tbody
        tr.clickable(v-for='rental in sorted_rentals' @click.prevent='viewRental(rental.number)')
          td {{ rental.number }}
          td {{ rental.name }}
          td {{ rental.pickup_location_name }}
          td {{ rental.vehicle }}
          td {{ rental.pickup | date_time }}
          td {{ rental.drop_off | date_time }}
</template>
