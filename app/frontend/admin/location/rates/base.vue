<script>
  import Form from 'Utils/form'
  import InputDate from 'Components/inputs/date'

  export default {
    name: 'rates',
    data () {
      return {
        rates: [],
        period: new Form({
          start_date: new Date(),
          end_date: new Date().setDate(new Date().getDate() + 7),
        })
      }
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
          .get(this.$route.path, params: this.period.data())
          .then(response => {
            this.rates = response.data
        })
      },
    },
  }
</script>

<template lang='pug'>
  h1 Rates

  .panel.panel-base.whole
    table.panel-table
      thead
        tr
          th Vehicle Type
      tbody.alternate-color
        tr(v-for='rate in rates')
          td rate.vehicle
</template>
