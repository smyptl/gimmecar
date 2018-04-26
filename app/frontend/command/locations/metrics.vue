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
  .panel.panel-base
    table.panel-table
      thead
        tr
          th Vehicle Type
          th.text-right Price / Mile
          th.text-right Average Rate
      tbody
        tr(v-for='metric in metrics')
          td {{ metric.vehicle_type   | capitalize }}
          td.text-right {{ metric.price_per_mile | currency }}
          td.text-right {{ metric.average_rate   | currency }}
</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/table'
</style>
