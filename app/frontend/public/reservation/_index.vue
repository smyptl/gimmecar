<script>
  import Axios from 'axios'
  import Moment from 'moment'

  import InputDateTime from 'Components/inputs/date_time'
  import InputError from 'Components/inputs/error'
  import InputErrorMessage from 'Components/inputs/error_message'

  import Rates from 'Admin/quotes/_rates'

  import SlideTransition from 'Utils/transitions/slide'
  import ErrorTransition from 'Utils/transitions/error'

  Axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest'

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
        summary: {},
        current_step: 'rental-details',
        transition_type: 'forward',
        errors: {}
      }
    },
    components: {
      InputDateTime,
      InputErrorMessage,
      Rates,
    },
    directives: {
      error: InputError,
    },
    methods: {
      viewRates() {
        Axios.get('/reservation', {
            params: {
              pickup: this.pickup,
              drop_off: this.drop_off,
            },
          })
          .then(response => {
            this.summary = response.data
            this.transition_type = 'forward'
            this.current_step = 'rental-summary'
            this.errors = {}
          })
          .catch(error => {
            this.errors = error.response.data.errors
            ErrorTransition(this.$el)
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
            this.summary = response.data
            this.transition_type = 'forward'
            this.current_step = 'rental-confirmation'
            this.errors = {}
          })
          .catch(error => {
            this.errors = error.response.data.errors
            ErrorTransition(this.$el)
          })
      },
      enter(el, done) {
        SlideTransition.enter(el, done, this.transition_type == 'forward')
      },
      leave(el, done) {
        SlideTransition.leave(el, done, this.transition_type == 'forward')
      },
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
          select.input-field.input-lg.input-contrast
            option(value='' disabled) Current, our only location.
            option(value='') Super 8 Redlands - 1160 Arizona St., Redlands, CA 92374
          input-error-message(value='location', :errors='errors')

      .input-row
        .input-container.one-half
          label.input-label.input-lg From:
          input-date-time.input-contrast(v-model='pickup' timezone='America/Los_Angeles')
          .input-block
            input-error-message(value='pickup', :errors='errors')

        .input-container.one-half
          label.input-label.input-lg To:
          input-date-time.input-contrast(v-model='drop_off' timezone='America/Los_Angeles')
          .input-block
            input-error-message(value='drop_off', :errors='errors')

        .input-submit
          .input-block.whole
            button.btn.btn-full.btn-primary.left(type='submit' @click='viewRates') View Rates

    #rental-summary.rental-invoice(v-if="current_step == 'rental-summary'" key='summary')
      rates(:summary='summary')

      .input-submit.input-flex-container
        .input-block.input-element-fixed
          button.btn(@click="current_step = 'rental-details', transition_type = 'backward'") Go Back
        .input-block.input-element-flex
          button.btn.btn-full.btn-primary(@click='newReservation') Reserve

    #rental-reserve(v-if="current_step == 'rental-reserve'" key='reserve')
      .input-row
        label.input-label.input-lg(for='last_name') Name
        .input-block.one-half.fixed
          input.input-field.input-lg.input-contrast(type='text' v-model='first_name' id='first_name' v-error:first_name='errors' placeholder='First')
          input-error-message(value='first_name', :errors='errors')
        .input-block.one-half.fixed
          input.input-field.input-lg.input-contrast(type='text' v-model='last_name' id='last_name' v-error:last_name='errors' placeholder='Last')
          input-error-message(value='last_name', :errors='errors')

      .input-row
        label.input-label.input-lg(for='input_email')
          | Email
          span.input-label-note.text-warning.right Valid email must be provided to confirm reservation.

        .input-block.whole
          input.input-field.input-lg.input-contrast(type='text' v-model='email' id='input_email' v-error:email='errors' placeholder='john@gmail.com')
          input-error-message(value='email', :errors='errors')

      .input-row
        label.input-label.input-lg(for='input_phone_number')
          | Phone #
          span.input-label-note.text-warning.right Valid number must be provided to confirm reservation.

        .input-block.whole
          input.input-field.input-lg.input-contrast(type='text' v-model='phone_number' id='input_phone_number' v-error:phone_number='errors' placeholder='805-555-1234')
          input-error-message(value='phone_number', :errors='errors')

      .input-submit.input-flex-container
        .input-block.input-element-fixed
          button.btn.btn-full(@click="current_step = 'rental-summary', transition_type = 'backward'") Go Back
        .input-block.input-element-flex
          button.btn.btn-full.btn-primary(@click='createReservation') Reserve Car

    #rental-confirmation.rental-invoice(v-if="current_step == 'rental-confirmation'" key='confirmation')
      h3.emoji :]
      p.text-center Thanks for choosing us, {{ first_name }}!!! You should receive a email shortly summarizing your rental. Additionally, we will give you a call shortly to confirm your reservation.

      rates(:summary='summary')

</template>
