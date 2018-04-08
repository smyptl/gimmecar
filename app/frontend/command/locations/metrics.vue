<script>
  import Capitalize from 'lodash/capitalize'
  import Currency   from 'Filters/currency'

  export default {
    name: 'Metrics',
    props: {
      metrics: {
        required: true,
        type: Array,
      },
    },
    filters: {
      Capitalize,
      Currency,
    },
  }
</script>

<template lang='pug'>
  .left
    .panel.panel-base(
      v-for='metric in metrics',
      :key='metric.vehicle_type'
    )
      .gimmecar-app-vertical-scroll
        table.panel-table
          thead
            tr
              th
              th.text-right(v-for='(_, month) in metric.metrics') {{ month }}
          tbody
            tr
              td {{ metric.vehicle_type | capitalize }}
              td.text-right(v-for='amount in metric.metrics') {{ amount | currency }}
</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/table'
</style>
