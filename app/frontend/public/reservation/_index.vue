<script>
  import Snabbt from 'snabbt.js'
  import Axios from 'axios'

  import InputDate from 'Components/inputs/date'
  import InputTime from 'Components/inputs/time'
  import InputError from 'Components/inputs/error'
  import InputErrorMessage from 'Components/inputs/error_message'

  export default {
    name: "reservation",
    data() {
      return {
        pickup_date: new Date,
        pickup_time: '9:00 PM',
        drop_off_date: new Date().setDate(new Date().getDate() + 1),
        drop_off_time: '9:00 PM',
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
      InputTime,
      InputErrorMessage,
    },
    directives: {
      error: InputError,
    },
    methods: {
      viewRates() {
        Axios.get('reservation', {
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
        .input-block
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
            input-time.input-lg(v-model='pickup_time' v-error:pickup_time='errors' name='pickup_time')
            input-error-message(value='pickup_time', :errors='errors')
          .input-block.whole
            input-error-message(value='pickup', :errors='errors')

        .input-container.one-half
          label.input-label.input-lg To:
          .input-block.one-half.fixed
            input-date.input-lg(v-model='drop_off_date' v-error:drop_off_date='errors' name='drop_off_date')
            input-error-message(value='drop_off_date', :errors='errors')
          .input-block.one-half.fixed
            input-time.input-lg(v-model='drop_off_time' v-error:drop_off_time='errors' name='drop_off_time')
            input-error-message(value='drop_off_time', :errors='errors')
          .input-block.whole
            input-error-message(value='drop_off', :errors='errors')

        .input-submit
          .input-block
            button.btn.btn-full.btn-primary.left(type='submit' @click='viewRates') View Rates

    #rental-summary(v-if="current_step == 'rental-summary'" key='summary')
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
            span.left {{ rate.date }}
            span.right {{ rate.value }}

        h6.margin-bottom-sm Taxes & Fees
        ul.left.whole.list-no-style
          li
            span.left Sales (8%)
            span.right {{ rental_summary.tax }}

        h5
          span.left Estimated Total:
          span.right {{ rental_summary.total }}


        .input-submit
          button.btn.btn-full(@click="current_step = 'rental-details', transition_type = 'backward'") Go Back
          button.btn.btn-primary.btn-full(@click='newReservation') Reserve

    #rental-reserve(v-if="current_step == 'rental-reserve'" key='reserve')
      .input-row
        label.input-label.input-lg Name
        .input-block.one-half.fixed
          input.input-field.input-lg(type='text' placeholder='First')
        .input-block.one-half.fixed
          input.input-field.input-lg(type='text' placeholder='Last')

      .input-row
        label.input-label.input-lg
          | Email
          span.input-label-note.text-warning.right Valid email must be provided to confirm reservation.

        .input-block
          input.input-field.input-lg(type='text' placeholder='johndoe@url.com')

      .input-row
        label.input-label.input-lg
          | Phone #
          span.input-label-note.text-warning.right Valid number must be provided to confirm reservation.

        .input-block
          input.input-field.input-lg(type='text' placeholder='805.555.1234')

      .input-submit
        .input-block.one-fifth.fixed
          button.btn.btn-full(@click="current_step = 'rental-summary', transition_type = 'backward'") Go Back
        .input-block.four-fifths.fixed
          button.btn.btn-full.btn-primary Reserve Car

    #rental-confirmation(v-if="current_step == 'rental-confirmation'" key='reserve')
</template>
