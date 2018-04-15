<script>
  import Capitalize from 'lodash/capitalize'
  import Currency   from 'Filters/currency'

  export default {
    name: 'Metrics',
    props: {
      metrics: {
        required: true,
        type: Object,
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
    table.panel-table.panel-table-key-pair
      thead
        tr
          th Vehicle Type
          th Price / Mile
      tbody
        tr(v-for='price_per_mile in metrics.price_per_mile')
          td {{ price_per_mile.vehicle_type | capitalize }}
          td {{ price_per_mile.metrics | currency }}
</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/table'
</style>
