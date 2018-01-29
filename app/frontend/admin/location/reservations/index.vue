<script>
  import Moment from 'moment'

  export default {
    name: 'index',
    data () {
      return {
        reservations: [],
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
    methods: {
      fetchData () {
        this.$http
          .get(this.$route.path)
          .then(response => {
            this.reservations = response.data
        })
      },
      viewRental (number) {
        this.$router.push({ name: 'rental', params: { number: number }})
      },
    },
  }
</script>

<template lang='pug'>
  .panel.panel-base.whole
    table.panel-table
      thead
        tr
          th #
          th Name
          th Vehicle
          th Pickup
          th Drop Off
      tbody.alternate-color
        tr(v-for='reservation in reservations')
          td {{ reservation.number }}
          td {{ reservation.name }}
          td {{ reservation.vehicle }}
          td {{ reservation.pickup | date_time }}
          td {{ reservation.drop_off | date_time }}
</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/table'

</style>
