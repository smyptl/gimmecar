<script>
  import Form from 'Utils/form'
  import InputDate from 'Components/inputs/date'
  import Rate from './_rate'

  import moment from 'moment'
  import { extendMoment } from 'moment-range';
  const Moment = extendMoment(moment);

  import FDate from 'Filters/date'

  export default {
    name: 'rates',
    data () {
      return {
        rates: [],
        period: new Form({
          start_date: Moment(),
          end_date: Moment().add(1, 'week'),
        })
      }
    },
    filters: {
      date: FDate,
    },
    components: {
      InputDate,
      Rate,
    },
    mounted () {
      this.fetchData()
    },
    watch: {
      '$route': 'fetchData',
    },
    computed: {
      date_range () {
        return Array.from(Moment.range(this.period.start_date, this.period.end_date).by('days', { exclusive: true }))
      },
    },
    methods: {
      fetchData () {
        this.$http
          .get(this.$route.path, { params: this.period.data() })
          .then(response => {
            this.rates = response.data
        })
      },
    },
  }
</script>

<template lang='pug'>
  .table-rates
    .table-vehicle-type
      table.panel-table.margin-top-default
        thead
          tr
            th Type
        tbody
          tr(v-for='rate in rates')
            td {{ rate.vehicle_type }}

    .table-rates
      table.panel-table.left.margin-top-default
        thead
          tr
            th.text-right(v-for='date in date_range') {{ date.format('M/D') }}
        tbody
          tr(v-for='rate in rates')
            rate(v-for='date in date_range' :date='date' :rates='rate' @update='fetchData()')
</template>

<style lang='stylus' scoped>

  .table-rates
    display: flex
    flex-direction: row
    flex: auto
    overflow-y: auto

  .table-vehicle-type
    flex: auto

</style>
