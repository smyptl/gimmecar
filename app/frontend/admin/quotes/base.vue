<script>
  import Axios from 'axios'
  Axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest'

  import Summary from './_summary'

  import InputDateTime from 'Components/inputs/date_time'

  export default {
    name: 'Quotes',
    data () {
      return {
        pickup: new Date().setHours(new Date().getHours() + 1),
        drop_off: new Date().setDate(new Date().getDate() + 1),
        step: 'rates',
      }
    },
    components: {
      'rates-summary': Summary,
      InputDateTime,
    },
    methods: {
      getRates () {
        this.step = 'summary'
      },
    },
  }

</script>

<template lang='pug'>
  .form-container
    template(v-if='step == "rates"')
      h4.form-header.form-header-first Rental Dates
      .input-row
        .input-container.one-half
          label.input-label From:
          input-date-time(v-model='pickup')

        .input-container.one-half
          label.input-label To:
          input-date-time(v-model='drop_off')

      .input-submit.input-block
        button.btn.btn-primary.right(@click='getRates') Rates
    rates-summary(v-if='step == "summary"')

</template>
