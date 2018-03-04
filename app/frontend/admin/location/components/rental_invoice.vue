<script>
  import FDate from "Filters/date"
  import FTime from "Filters/time"
  import Currency from 'Filters/currency'
  import Percent from 'Filters/percent'

  import SortBy from 'lodash/sortBy'

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
      time: FTime,
    },
    computed: {
      rates () {
        return SortBy(this.summary.rates, ['date'])
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
        b {{ summary.location.description }}

      li
        | Vehicle:&nbsp;
        b {{ summary.vehicle.make_model }}
        template(v-if='summary.vehicle.vin') &nbsp; {{ summary.vehicle.vin }}

      li
        | Pickup:&nbsp;
        b {{ summary.pickup | time }}
      li(v-if='summary.pickup_fuel')
        | Pickup Fuel:&nbsp;
        b {{ summary.pickup_fuel/10 | percent }}
      li(v-if='summary.pickup_fuel')
        | Pickup Odometer:&nbsp;
        b {{ summary.pickup_odometer }}

      li
        | Drop Off:&nbsp;
        b {{ summary.drop_off | time }}
      li(v-if='summary.drop_off_fuel')
        | Drop Off Fuel:&nbsp;
        b {{ summary.drop_off_fuel/10 | percent }}
      li(v-if='summary.drop_off_odometer')
        | Drop Off Odometer:&nbsp;
        b {{ summary.drop_off_odometer }}


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

    p.left.whole(v-if='summary.deposit')
      span.left Deposit
      span.right {{ summary.deposit.total | currency }}

</template>
