<script>
  import FDate from "Filters/date"
  import FDateTime from "Filters/date_time"
  import Currency from 'Filters/currency'
  import Percent from 'Filters/percent'

  import Filter from 'lodash/filter'
  import SumBy from 'lodash/sumBy'

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
    computed: {
      rates () {
        return Filter(this.summary.line_items, { item_type: "rate" })
      },
    },
  }
</script>

<template lang='pug'>
  .rental-invoice-summary.whole
    h4.margin-bottom-sm Rental Details
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

    h4.margin-bottom-sm Rates
    ul.left.whole.list-no-style
      li(v-for='rate in rates')
        span.left {{ rate.date | date }}
        span.right {{ rate.amount | currency }}

    h4.margin-bottom-sm Taxes & Fees
    ul.left.whole.list-no-style
      li
        span.left Sales Tax - {{ summary.combined_tax_rate | percent }}
        span.right {{ summary.tax_collectable | currency }}

    h4.invoice-one-line
      span.left
        template(v-if='estimated') Estimated&nbsp;
        | Total:
      span.right {{ summary.total | currency }}

    p.left.whole
      span.left Deposit
      span.right $100.00

</template>
