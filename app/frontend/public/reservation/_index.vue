<script>
  import Snabbt from 'snabbt.js'
  import Axios from 'axios'
  import Moment from 'moment'

  import InputDateTime from 'Components/inputs/date_time'
  import InputError from 'Components/inputs/error'
  import InputErrorMessage from 'Components/inputs/error_message'

  import FDate from "Filters/date"
  import Currency from 'Filters/currency'

  export default {
    name: "reservation",
    data() {
      return {
        pickup: new Date().setHours(new Date().getHours() + 1),
        drop_off: new Date().setDate(new Date().getDate() + 1),
        first_name: '',
        last_name: '',
        email: '',
        phone_number: '',
        rental_summary: {},
        current_step: 'rental-details',
        leaving_element_height: null,
        entering_element_height: null,
        transition_type: 'forward',
        errors: {}
      }
    },
    components: {
      InputDateTime,
      InputErrorMessage,
    },
    filters: {
      date: FDate,
      Currency,
    },
    directives: {
      error: InputError,
    },
    computed: {
      pickup_date () {
        return Moment(this.pickup).format('LL')
      },
      pickup_time () {
        return Moment(this.pickup).format('LT')
      },
      drop_off_date () {
        return Moment(this.drop_off).format('LL')
      },
      drop_off_time () {
        return Moment(this.drop_off).format('LT')
      },
    },
    methods: {
      viewRates() {
        Axios.get('/reservation', {
            params: {
              pickup: this.pickup,
              drop_off: this.drop_off,
            }
          })
          .then(response => {
            this.rental_summary = response.data
            this.transition_type = 'forward'
            this.current_step = 'rental-summary'
            this.errors = {}
          })
          .catch(error => {
            this.errors = error.response.data.errors
            this.shake(this.$el)
          })
      },
      newReservation() {
        this.transition_type = 'forward'
        this.current_step = 'rental-reserve'
      },
      createReservation() {
        Axios.post('/reservation', {
            first_name: this.first_name,
            last_name: this.last_name,
            email: this.email,
            phone_number: this.phone_number,
            pickup: this.pickup,
            drop_off: this.drop_off,
          },
          {
            headers: {
              'X-CSRF-Token': document.getElementsByName('csrf-token')[0].content,
            }
          })
          .then(response => {
            this.rental_summary = response.data
            this.transition_type = 'forward'
            this.current_step = 'rental-confirmation'
            this.errors = {}
          })
          .catch(error => {
            this.errors = error.response.data.errors
            this.shake(this.$el)
          })
      },
      enter(el, done) {
        if (this.transition_type == 'forward') {
          this.fadeIn(el, done, { scale: [1, 1], fromScale: [0.99, 0.99]})
        } else {
          this.fadeIn(el, done, { scale: [1, 1], fromScale: [1.01, 1.01]})
        }
      },
      leave(el, done) {
        if (this.transition_type == 'forward') {
          this.fadeOut(el, done, { scale: [1.01, 1.01], fromScale: [1, 1]})
        } else {
          this.fadeOut(el, done, { scale: [0.99, 0.99], fromScale: [1, 1]})
        }
      },
      shake(el) {
        Snabbt(el, 'attention', {
          position: [50, 0, 0],
          springConstant: 2.4,
          springDeceleration: 0.9,
        })
      },
      fadeIn(el, done, settings) {
        Snabbt(el, {
          opacity: 1,
          fromOpacity: 0.01,
          scale: settings.scale,
          fromScale: settings.fromScale,
          easing: 'ease',
          duration: 200,
          complete() {
            done()
          },
        })
      },
      fadeOut(el, done, settings) {
        Snabbt(el, {
          opacity: 0.01,
          fromOpacity: 1,
          scale: settings.scale,
          fromScale: settings.fromScale,
          easing: 'ease',
          duration: 200,
          complete() {
            done()
          },
        })
      }
    },
  }
</script>

<template lang='pug'>
  transition(
    mode='out-in'
    v-on:enter='enter'
    v-on:leave='leave')

    #rental-details(v-if="current_step == 'rental-details'" key='details')
      .input-row
        label.input-label.input-lg Where:
        .input-block.whole
          select.input-field.input-lg
            option(value='' disabled) Current, our only location.
            option(value='') Super 8 Redlands - 1160 Arizona St., Redlands, CA 92374
          input-error-message(value='location', :errors='errors')

      .input-row
        .input-container.one-half
          label.input-label.input-lg From:
          input-date-time(v-model='pickup' timezone='America/Los_Angeles')
          .input-block
            input-error-message(value='pickup', :errors='errors')

        .input-container.one-half
          label.input-label.input-lg To:
          input-date-time(v-model='drop_off' timezone='America/Los_Angeles')
          .input-block
            input-error-message(value='drop_off', :errors='errors')

        .input-submit
          .input-block.whole
            button.btn.btn-full.btn-primary.left(type='submit' @click='viewRates') View Rates

    #rental-summary.rental-invoice(v-if="current_step == 'rental-summary'" key='summary')
      .input-block.margin-top-default
        h6.margin-bottom-sm Rental Details
        ul.left.whole.list-no-style
          li
            | Vehicle:&nbsp;
            b {{ rental_summary.vehicle }}
          li
            | Location:&nbsp;
            b {{ rental_summary.location }}

          li
            | Pick Up:&nbsp;
            b {{ pickup_date }} @ {{ pickup_time }}

          li
            | Return:&nbsp;
            b {{ drop_off_date }} @ {{ drop_off_time }}


        h6.margin-bottom-sm Rates
        ul.left.whole.list-no-style
          li(v-for='rate in rental_summary.rates')
            span.left {{ rate.date | date }}
            span.right {{ rate.value | currency }}

        h6.margin-bottom-sm Taxes & Fees
        ul.left.whole.list-no-style
          li
            span.left Sales (8%)
            span.right {{ rental_summary.tax | currency }}

        h5
          span.left Estimated Total:
          span.right {{ rental_summary.total | currency }}


      .input-submit.input-flex-container
        .input-block.input-element-fixed
          button.btn(@click="current_step = 'rental-details', transition_type = 'backward'") Go Back
        .input-block.input-element-flex
          button.btn.btn-full.btn-primary(@click='newReservation') Reserve

    #rental-reserve(v-if="current_step == 'rental-reserve'" key='reserve')
      .input-row
        label.input-label.input-lg Name
        .input-block.one-half.fixed
          input.input-field.input-lg(type='text' v-model='first_name' v-error:first_name='errors' placeholder='First')
          input-error-message(value='first_name', :errors='errors')
        .input-block.one-half.fixed
          input.input-field.input-lg(type='text' v-model='last_name' v-error:last_name='errors' placeholder='Last')
          input-error-message(value='last_name', :errors='errors')

      .input-row
        label.input-label.input-lg
          | Email
          span.input-label-note.text-warning.right Valid email must be provided to confirm reservation.

        .input-block.whole
          input.input-field.input-lg(type='text' v-model='email' v-error:email='errors' placeholder='john@gmail.com')
          input-error-message(value='email', :errors='errors')

      .input-row
        label.input-label.input-lg
          | Phone #
          span.input-label-note.text-warning.right Valid number must be provided to confirm reservation.

        .input-block.whole
          input.input-field.input-lg(type='text' v-model='phone_number' v-error:phone_number='errors' placeholder='805-555-1234')
          input-error-message(value='phone_number', :errors='errors')

      .input-submit.input-flex-container
        .input-block.input-element-fixed
          button.btn.btn-full(@click="current_step = 'rental-summary', transition_type = 'backward'") Go Back
        .input-block.input-element-flex
          button.btn.btn-full.btn-primary(@click='createReservation') Reserve Car

    #rental-confirmation.rental-invoice(v-if="current_step == 'rental-confirmation'" key='confirmation')
      h3.emoji :]
      p.text-center Thanks for choosing us, {{ first_name }}!!! You should receive a email shortly summarizing your rental. Additionally, we will give you a call shortly to confirm your reservation.

      h6.margin-bottom-sm.margin-top-default Rental Confirmation
      ul.left.whole.list-no-style
        li
          | Confirmation #:&nbsp;
          b {{ rental_summary.confirmation_number }}
        li
          | Vehicle:&nbsp;
          b {{ rental_summary.vehicle }}
        li
          | Location:&nbsp;
          b {{ rental_summary.location }}

        li
          | Pick Up:&nbsp;
          b {{ pickup_date }} @ {{ pickup_time }}

        li
          | Return:&nbsp;
          b {{ drop_off_date }} @ {{ drop_off_time }}


      h6.margin-bottom-sm Rates
      ul.left.whole.list-no-style
        li(v-for='rate in rental_summary.rates')
          span.left {{ rate.date | date }}
          span.right {{ rate.value | currency }}

      h6.margin-bottom-sm Taxes & Fees
      ul.left.whole.list-no-style
        li
          span.left Sales (8%)
          span.right {{ rental_summary.tax | currency }}

      h5
        span.left Estimated Total:
        span.right {{ rental_summary.total | currency }}

</template>
