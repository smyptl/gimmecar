<script>
  import Currency from 'Filters/currency'

  import Values from 'lodash/values'
  import Size from 'lodash/size'
  import SumBy from 'lodash/sumBy'

  export default {
    name: 'Monthly-Revenue',
    props: {
      revenue: {
        type: Object,
        required: true,
      },
    },
    filters: {
      Currency,
    },
    computed: {
      total () {
        return SumBy(Values(this.revenue), v => { return parseInt(v) })
      },
      average () {
        return this.total/Size(this.revenue)
      }
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
        tr
          td Avg.
          td {{ average | currency }}
</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/table'
</style>
