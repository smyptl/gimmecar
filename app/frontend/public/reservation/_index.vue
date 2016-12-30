<script>
  import Snabbt from 'snabbt.js'
  import Axios from 'axios'

  import InputDate from 'Components/inputs/date'
  import InputError from 'Components/inputs/error'
  import InputErrorMessage from 'Components/inputs/error_message'

  import FDate from "Filters/date"
  import Currency from 'Filters/currency'

  export default {
    name: "reservation",
    data() {
      return {
        pickup_date: new Date,
        pickup_time: '11:00 PM',
        drop_off_date: new Date().setDate(new Date().getDate() + 1),
        drop_off_time: '11:00 PM',
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
      InputDate,
      InputErrorMessage,
    },
    filters: {
      date: FDate,
      Currency,
    },
    directives: {
      error: InputError,
    },
    methods: {
      viewRates() {
        Axios.get('/reservation', {
            params: {
              pickup_date: this.pickup_date,
              pickup_time: this.pickup_time,
              drop_off_date: this.drop_off_date,
              drop_off_time: this.drop_off_time,
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
            pickup_date: this.pickup_date,
            pickup_time: this.pickup_time,
            drop_off_date: this.drop_off_date,
            drop_off_time: this.drop_off_time,
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

          .input-block.one-half.fixed
            input-date.input-lg(v-model='pickup_date' v-error:pickup_date='errors' name='pickup_date')
            input-error-message(value='pickup_date', :errors='errors')
          .input-block.one-half.fixed
            select.input-field.input-lg(v-model='pickup_time' v-error:pickup_time='errors' placeholder='--:-- AM/PM' name='pickup_time')
              option(value='' disabled) --:-- AM/PM
              option(value='12:00 AM') 12:00 AM
              option(value='12:30 AM') 12:30 AM
              option(value='1:00 AM') 1:00 AM
              option(value='1:30 AM') 1:30 AM
              option(value='2:00 AM') 2:00 AM
              option(value='2:30 AM') 2:30 AM
              option(value='3:00 AM') 3:00 AM
              option(value='3:30 AM') 3:30 AM
              option(value='4:00 AM') 4:00 AM
              option(value='4:30 AM') 4:30 AM
              option(value='5:00 AM') 5:00 AM
              option(value='5:30 AM') 5:30 AM
              option(value='6:00 AM') 6:00 AM
              option(value='6:30 AM') 6:30 AM
              option(value='7:00 AM') 7:00 AM
              option(value='7:30 AM') 7:30 AM
              option(value='8:00 AM') 8:00 AM
              option(value='8:30 AM') 8:30 AM
              option(value='8:00 AM') 8:00 AM
              option(value='8:30 AM') 8:30 AM
              option(value='9:00 AM') 9:00 AM
              option(value='9:30 AM') 9:30 AM
              option(value='10:00 AM') 10:00 AM
              option(value='10:30 AM') 10:30 AM
              option(value='11:00 AM') 11:00 AM
              option(value='11:30 AM') 11:30 AM
              option(value='12:00 PM') 12:00 PM
              option(value='12:30 PM') 12:30 PM
              option(value='1:00 PM') 1:00 PM
              option(value='1:30 PM') 1:30 PM
              option(value='2:00 PM') 2:00 PM
              option(value='2:30 PM') 2:30 PM
              option(value='3:00 PM') 3:00 PM
              option(value='3:30 PM') 3:30 PM
              option(value='4:00 PM') 4:00 PM
              option(value='4:30 PM') 4:30 PM
              option(value='5:00 PM') 5:00 PM
              option(value='5:30 PM') 5:30 PM
              option(value='6:00 PM') 6:00 PM
              option(value='6:30 PM') 6:30 PM
              option(value='7:00 PM') 7:00 PM
              option(value='7:30 PM') 7:30 PM
              option(value='8:00 PM') 8:00 PM
              option(value='8:30 PM') 8:30 PM
              option(value='9:00 PM') 9:00 PM
              option(value='9:30 PM') 9:30 PM
              option(value='10:00 PM') 10:00 PM
              option(value='10:30 PM') 10:30 PM
              option(value='11:00 PM') 11:00 PM
              option(value='11:30 PM') 11:30 PM
            input-error-message(value='pickup_time', :errors='errors')
          .input-block.whole
            input-error-message(value='pickup', :errors='errors')

        .input-container.one-half
          label.input-label.input-lg To:
          .input-block.one-half.fixed
            input-date.input-lg(v-model='drop_off_date' v-error:drop_off_date='errors' name='drop_off_date')
            input-error-message(value='drop_off_date', :errors='errors')
          .input-block.one-half.fixed
            select.input-field.input-lg(v-model='drop_off_time' v-error:drop_off_time='errors' placeholder='--:-- AM/PM' name='drop_off_time')
              option(value='' disabled) --:-- AM/PM
              option(value='12:00 AM') 12:00 AM
              option(value='12:30 AM') 12:30 AM
              option(value='1:00 AM') 1:00 AM
              option(value='1:30 AM') 1:30 AM
              option(value='2:00 AM') 2:00 AM
              option(value='2:30 AM') 2:30 AM
              option(value='3:00 AM') 3:00 AM
              option(value='3:30 AM') 3:30 AM
              option(value='4:00 AM') 4:00 AM
              option(value='4:30 AM') 4:30 AM
              option(value='5:00 AM') 5:00 AM
              option(value='5:30 AM') 5:30 AM
              option(value='6:00 AM') 6:00 AM
              option(value='6:30 AM') 6:30 AM
              option(value='7:00 AM') 7:00 AM
              option(value='7:30 AM') 7:30 AM
              option(value='8:00 AM') 8:00 AM
              option(value='8:30 AM') 8:30 AM
              option(value='8:00 AM') 8:00 AM
              option(value='8:30 AM') 8:30 AM
              option(value='9:00 AM') 9:00 AM
              option(value='9:30 AM') 9:30 AM
              option(value='10:00 AM') 10:00 AM
              option(value='10:30 AM') 10:30 AM
              option(value='11:00 AM') 11:00 AM
              option(value='11:30 AM') 11:30 AM
              option(value='12:00 PM') 12:00 PM
              option(value='12:30 PM') 12:30 PM
              option(value='1:00 PM') 1:00 PM
              option(value='1:30 PM') 1:30 PM
              option(value='2:00 PM') 2:00 PM
              option(value='2:30 PM') 2:30 PM
              option(value='3:00 PM') 3:00 PM
              option(value='3:30 PM') 3:30 PM
              option(value='4:00 PM') 4:00 PM
              option(value='4:30 PM') 4:30 PM
              option(value='5:00 PM') 5:00 PM
              option(value='5:30 PM') 5:30 PM
              option(value='6:00 PM') 6:00 PM
              option(value='6:30 PM') 6:30 PM
              option(value='7:00 PM') 7:00 PM
              option(value='7:30 PM') 7:30 PM
              option(value='8:00 PM') 8:00 PM
              option(value='8:30 PM') 8:30 PM
              option(value='9:00 PM') 9:00 PM
              option(value='9:30 PM') 9:30 PM
              option(value='10:00 PM') 10:00 PM
              option(value='10:30 PM') 10:30 PM
              option(value='11:00 PM') 11:00 PM
              option(value='11:30 PM') 11:30 PM
            input-error-message(value='drop_off_time', :errors='errors')
          .input-block.whole
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
