<script>
  import FDate from "Filters/date"
  import FDateTime from "Filters/date_time"
  import Currency from 'Filters/currency'
  import Percent from 'Filters/percent'

  export default {
    props: {
      summary: {
        required: true,
        type: Object,
      },
    },
    filters: {
      Currency,
      Percent,
      date: FDate,
      date_time: FDateTime,
    },
  }
</script>

<template lang='pug'>
  .input-block.margin-top-default.whole
    h6.margin-bottom-sm Rental Details
    ul.left.whole.list-no-style
      li(v-if='summary.confirmation_number')
        | Confirmation Number:&nbsp;
        b {{ summary.confirmation_number }}

      li
        | Location:&nbsp;
        b {{ summary.location }}

      li
        | Vehicle:&nbsp;
        b {{ summary.vehicle }}

      li
        | Pick Up:&nbsp;
        b {{ summary.pickup | date_time }}

      li
        | Return:&nbsp;
        b {{ summary.drop_off | date_time }}

    h6.margin-bottom-sm Rates
    ul.left.whole.list-no-style
      li(v-for='rate in summary.rates')
        span.left {{ rate.date | date }}
        span.right {{ rate.value | currency }}

    h6.margin-bottom-sm Taxes & Fees
    ul.left.whole.list-no-style
      li
        span.left Sales ({{ summary.tax.rate | percent }})
        span.right {{ summary.tax.value | currency }}

    h5
      span.left Estimated Total:
      span.right {{ summary.total | currency }}
</template>

<style lang='stylus' scoped>
  @import '~Styles/global/colors'
  @import '~Styles/global/layout'

  h6
    float: left
    width: 100%
    margin-bottom: $margin-sm
    padding-bottom: $padding-sm

    border-bottom: 1px solid $border-color-dark

  h5
    float: left
    width: 100%
    border-top: 2px solid $border-color-dark
    padding-top: $padding-sm

  ul
    margin-bottom: $margin-default

  li
    float: left
    width: 100%
    margin-bottom: $margin-sm * 0.75

    font-size: 0.875rem

</style>
