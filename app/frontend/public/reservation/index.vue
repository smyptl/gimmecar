<script>
  import Form from 'Utils/form'

  import InputDateTime from './date_time'
  import InputError from 'Components/inputs/error'
  import InputErrorMessage from 'Components/inputs/error_message'

  import Rates from 'Admin/location/quotes/summary'

  import SlideTransition from 'Utils/transitions/slide'
  import ErrorTransition from 'Utils/transitions/shake'

  export default {
    name: 'reservation',
    data() {
      return {
        form: new Form({
          pickup: new Date().setDate(new Date().getDate() + 1),
          drop_off: new Date().setDate(new Date().getDate() + 2),
          first_name: '',
          last_name: '',
          email: '',
          phone_number: '',
        }),
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
        this.$http.get('/reservation', {
            params: {
              pickup: this.form.pickup,
              drop_off: this.form.drop_off,
            },
          })
          .then(response => {
            this.summary = response.data
            this.transition_type = 'forward'
            this.current_step = 'rental-summary'
            this.errors = {}
          })
          .catch(error => {
            this.form.errors.record(error.response.data.errors)
            ErrorTransition(this.$el)
          })
      },
      newReservation() {
        this.transition_type = 'forward'
        this.current_step = 'rental-reserve'
      },
      createReservation() {
        this.$http.post('/reservation', this.form.data())
          .then(response => {
            this.summary = response.data
            this.transition_type = 'forward'
            this.current_step = 'rental-confirmation'
            this.errors = {}
          })
          .catch(error => {
            this.form.errors.record(error.response.data.errors)
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
  #reservation-panel

    transition(
      mode='out-in'
      v-on:enter='enter'
      v-on:leave='leave')

      #rental-details(v-if="current_step == 'rental-details'" key='details')
        form(@submit.prevent='viewRates')
          .input-row
            label.input-label.input-lg Where:
            .input-block.whole
              select.input-field.input-lg
                option(value='' disabled) Current, our only location.
                option(value='') Super 8 Redlands - 1160 Arizona St., Redlands, CA 92374
              input-error-message(field='location' v-bind:errors='form.errors.get("location")')

          .input-row
            .input-container.one-half
              label.input-label.input-lg From:
              input-date-time(v-model='form.pickup' timezone='America/Los_Angeles')
              input-error-message.input-message-lg(field='pickup' v-bind:errors='form.errors.get("pickup")')

            .input-container.one-half
              label.input-label.input-lg To:
              input-date-time(v-model='form.drop_off' timezone='America/Los_Angeles')
              input-error-message.input-message-lg(field='drop_off' v-bind:errors='form.errors.get("drop_off")')

            .input-submit
              .input-block.whole
                input.btn.btn-full.btn-primary(type='submit' value='View Rates')

      #rental-summary.rental-invoice(v-if="current_step == 'rental-summary'" key='summary')
        rates(:summary='summary')

        .input-submit.input-flex-container
          .input-block.input-element-fixed
            button.btn(@click="current_step = 'rental-details', transition_type = 'backward'") Go Back
          .input-block.input-element-flex
            button.btn.btn-full.btn-primary(@click='newReservation') Reserve

      #rental-reserve(v-if="current_step == 'rental-reserve'" key='reserve')
        form(@submit.prevent='createReservation')
          .input-row
            label.input-label.input-lg(for='first_name') Name
            .input-container.one-half.fixed
              .input-block.whole
                input.input-field#first_name(
                  type='text'
                  placeholder='Henry'
                  v-model='form.first_name'
                  v-error='form.errors.has("first_name")'
                  @input='form.errors.clear("first_name")')

              input-error-message.input-message-lg(field='first_name' v-bind:errors='form.errors.get("first_name")')

            .input-container.one-half.fixed
              .input-block.whole
                input.input-field#last_name(
                  type='text'
                  placeholder='Ford'
                  v-model='form.last_name'
                  v-error='form.errors.has("last_name")'
                  @input='form.errors.clear("last_name")')

              input-error-message.input-message-lg(field='last_name' v-bind:errors='form.errors.get("last_name")')

          .input-row
            label.input-label.input-lg(for='input_email')
              | Email
              span.input-label-note.text-warning.right Valid email must be provided to confirm reservation.

            .input-block.whole
              input.input-field#input_email(
                type='email'
                placeholder='hford@gmail.com'
                v-model='form.email'
                v-error='form.errors.has("email")'
                @input='form.errors.clear("email")')

            input-error-message.input-message-lg(field='email' v-bind:errors='form.errors.get("email")')

          .input-row
            label.input-label.input-lg(for='input_phone_number')
              | Phone #
              span.input-label-note.text-warning.right Valid number must be provided to confirm reservation.

            .input-block.whole
              input.input-field#input_phone_number(
                type='number'
                placeholder='805-990-1234'
                v-model='form.phone_number'
                v-error='form.errors.has("phone_number")'
                @input='form.errors.clear("phone_number")')

            input-error-message.input-message-lg(field='phone_number' v-bind:errors='form.errors.get("phone_number")')


          .input-submit.input-flex-container
            .input-block.input-element-fixed
              button.btn.btn-full(@click.prevent="current_step = 'rental-summary', transition_type = 'backward'") Go Back
            .input-block.input-element-flex
              input.btn.btn-full.btn-primary(type='submit' value='Reserve Car')

      #rental-confirmation.rental-invoice(v-if="current_step == 'rental-confirmation'" key='confirmation')
        h3.emoji :]
        p.text-center Thanks for choosing us, {{ form.first_name }}!!! You should receive a email shortly summarizing your rental. Additionally, we will give you a call shortly to confirm your reservation.

        rates(:summary='summary')
</template>


<style lang='stylus'>
  @import '~Styles/global/colors'
  @import '~Styles/global/layout'

  .input-field
    background-color: #f7f7f7
</style>
