<script>
  import FDate from "Filters/date"
  import FDateTime from "Filters/date_time"
  import Currency from 'Filters/currency'

  export default {
    props: {
      summary: {
        required: true,
        type: Object,
      },
    },
    filters: {
      Currency,
      date: FDate,
      date_time: FDateTime,
    },
  }
</script>

<template lang='pug'>
  .input-block.margin-top-default
    h6.margin-bottom-sm Rental Details
    ul.left.whole.list-no-style
      li(v-if='summary.confirmation_number')
        | Confirmation Number:&nbsp;
        b {{ summary.confirmation_number }}
      li
        | Vehicle:&nbsp;
        b {{ summary.vehicle }}
      li
        | Location:&nbsp;
        b {{ summary.location }}

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
        span.left Sales (8%)
        span.right {{ summary.tax | currency }}

    h5
      span.left Estimated Total:
      span.right {{ summary.total | currency }}
</template>
