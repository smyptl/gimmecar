<script>
  import Form from 'Utils/form'
  import Shake from 'Utils/transitions/shake'

  import Quote from 'Admin/location/components/rental_invoice'

  import InputDateTime from 'Components/inputs/date_time'

  export default {
    name: 'new',
    data () {
      return {
        quote: new Form({
          pickup: new Date().setHours(new Date().getHours() + 1),
          drop_off: new Date().setDate(new Date().getDate() + 1),
        }),
        step: 'rates',
        summary: {},
      }
    },
    components: {
      Quote,
      InputDateTime,
    },
    methods: {
      getRates () {
        this.$http.post(this.$route.path, {
          quote: this.quote.data(),
        })
        .then(response => {
          this.quote.errors.clear
          this.summary = response.data
          this.step = 'summary'
        })
        .catch(error => {
          Shake(document.getElementById('quote-form'))
          this.quote.errors.record(error.response.data.errors)
        })
      },
    },
  }

</script>

<template lang='pug'>
  .form-container
    #quote-form(v-if='step == "rates"')
      h4.form-header.form-header-first
        | Reservation (Rates)
        small.right 1 of 10
      form(@submit.prevent='getRates()')
        .input-row
          .input-container.one-half
            label.input-label From:
            input-date-time(
              v-model='quote.pickup'
              v-error='quote.errors.has("pickup")'
              @input='quote.errors.clear("pickup")')

            input-error-message(field='pickup' v-bind:errors='quote.errors.get("pickup")')

          .input-container.one-half
            label.input-label To:
            input-date-time(
              v-model='quote.drop_off'
              v-error='quote.errors.has("drop_off")'
              @input='quote.errors.clear("drop_off")')

            input-error-message(field='drop_off' v-bind:errors='quote.errors.get("drop_off")')

        .input-submit.input-block
          input.btn.btn-primary.right(type='submit' value='Rates')

    template(v-if='step == "summary"')
      h4.form-header.form-header-first Quote
      quote(v-bind:summary='summary')

      .input-submit.input-flex-container
        .input-block.input-element-fixed
          button.btn(@click="current_step = 'rates', transition_type = 'backward'") Go Back
        .input-block.input-element-flex
          button.btn.btn-full.btn-primary(@click='newReservation') Reservation
        .input-block.input-element-flex
          button.btn.btn-full.btn-primary(@click='newRental') Rental


</template>
