<script>
  import Currency from 'Filters/currency'

  import Values from 'lodash/values'
  import SumBy from 'lodash/sumBy'

  export default {
    name: 'Reports',
    data () {
      return {
        revenue: {},
      }
    },
    filters: {
      Currency
    },
    created () {
      this.getData()
    },
    watch: {
      '$route': 'getData',
    },
    computed: {
      total () {
        return SumBy(Values(this.revenue), v => { return parseInt(v) })
      },
    },
    methods: {
      getData () {
        this.$http
          .get(this.$route.path)
          .then(response => {
            this.revenue = response.data
        })
      },
    },
  }
</script>

<template lang='pug'>
  .panel.panel-base
    table.panel-table.panel-table-key-pair
      thead
        tr
          th Month
          th Revenue
      tbody
        tr(v-for='(rev, month) in revenue')
          td {{ month }}
          td {{ rev | currency }}
      tfoot
        tr
          td Total
          td {{ total | currency }}

</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/table'
</style>
