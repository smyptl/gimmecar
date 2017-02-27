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
        default: false,
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
  .rental-invoice-summary.input-block.whole
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
      li(v-for='rate in summary.details')
        span.left {{ rate.date | date }}
        span.right {{ rate.value | currency }}

    h5.margin-bottom-sm Taxes & Fees
    ul.left.whole.list-no-style
      li
        span.left Sales ({{ summary.tax_rate | percent }})
        span.right {{ summary.tax | currency }}

    h5.invoice-one-line
      span.left
        template(v-if='estimated') Estimated&nbsp;
        | Total:
      span.right {{ summary.total | currency }}
    p.left.whole
      span.left Deposit
      span.right $100.00

</template>
