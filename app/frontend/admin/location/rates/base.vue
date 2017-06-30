<script>
  import Form from 'Utils/form'
  import InputDate from 'Components/inputs/date'

  import moment from 'moment'
  import { extendMoment } from 'moment-range';
  const Moment = extendMoment(moment);

  import Find from 'lodash/find'

  import FDate from 'Filters/date'
  import Currency from 'Filters/currency'

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
      Currency,
    },
    components: {
      InputDate,
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
      find_rate (rates, date) {
        let rate = Find(rates, function (r) {
          return date.isSame(r.date, 'day')
        })

        if (rate) {
          return rate.amount
        }

        return null
      }
    },
  }
</script>

<template lang='pug'>
  .panel.panel-base.whole
    .table-rates
      .table-vehicle-type
        table.panel-table.left
          thead
            tr
              th Type
          tbody.alternate-color
            tr(v-for='rate in rates')
              td {{ rate.vehicle_type }}

      .table-rates
        table.panel-table.left
          thead
            tr
              th.text-right(v-for='date in date_range') {{ date.format('M/D') }}
          tbody.alternate-color
            tr(v-for='rate in rates')
              td.text-right(v-for='date in date_range')
                span(v-if='find_rate(rate.rates, date)') {{ find_rate(rate.rates, date) | currency }}
                span.text-light(v-else) {{ rate.default_rate | currency }}

</template>

<style lang='stylus' scoped>

  .table-rates
    display: flex
    flex-direction: row

  .table-vehicle-type
    flex: auto

  .table-rates
    flex: auto

    overflow-y: auto

</style>
