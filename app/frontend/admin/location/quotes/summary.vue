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
      estimated: {
        type: Boolean,
        default: true,
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
  .input-block.whole
    h5.margin-bottom-sm Rental Details
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
        | Pickup:&nbsp;
        b {{ summary.pickup | date_time }}

      li
        | Drop Off:&nbsp;
        b {{ summary.drop_off | date_time }}

    h5.margin-bottom-sm Rates
    ul.left.whole.list-no-style
      li(v-for='rate in summary.rates')
        span.left {{ rate.date | date }}
        span.right {{ rate.value | currency }}

    h5.margin-bottom-sm Taxes & Fees
    ul.left.whole.list-no-style
      li
        span.left Sales ({{ summary.tax.rate | percent }})
        span.right {{ summary.tax.value | currency }}

    h5.invoice-one-line
      span.left
        template(v-if='estimated') Estimated&nbsp;
        | Total:
      span.right {{ summary.total | currency }}
    ul.left.whole.list-no-style
      li
        span.left Deposit
        span.right $100.00
</template>

<style lang='stylus' scoped>
  @import '~Styles/global/colors'
  @import '~Styles/global/layout'

  h5
    float: left
    width: 100%
    border-bottom: 0.0625rem solid $border-color-dark
    padding-bottom: $padding-sm

  h5.invoice-one-line
    padding-top: $padding-sm
    padding-bottom: 0
    border-top: 0.15rem solid $border-color-dark
    border-bottom: 0

  ul
    margin-bottom: $margin-default

  li
    float: left
    width: 100%
    margin-bottom: $margin-sm * 0.75

    font-size: 0.875rem

</style>
