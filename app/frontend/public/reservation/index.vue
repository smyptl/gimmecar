<script>
  import Form from 'Utils/form'

  import InputSubmit from 'Mixins/input_submit'

  import InputVehicleTypes from 'Components/inputs/vehicle_types'
  import InputDateTime     from 'Components/inputs/date_time'
  import InputError        from 'Components/inputs/error'
  import InputErrorMessage from 'Components/inputs/error_message'

  import RentalInvoice from 'Components/quote'

  import SlideTransition from 'Utils/transitions/slide'
  import ErrorTransition from 'Utils/transitions/shake'

  export default {
    name: 'Reservation',
    data() {
      return {
        form: new Form({
          pickup: new Date().setDate(new Date().getDate() + 1),
          drop_off: new Date().setDate(new Date().getDate() + 2),
          location_id: '1',
          vehicle_type: '',
          name_first: '',
          name_last: '',
          email: '',
          phone_number: '',
        }),
        summary: {},
        current_step: 'rental-details',
        transition_type: 'forward',
        errors: {}
      }
    },
    mixins: [
      InputSubmit,
    ],
    components: {
      InputDateTime,
      InputErrorMessage,
      InputVehicleTypes,
      RentalInvoice,
    },
    directives: {
      error: InputError,
    },
    methods: {
      viewRates() {
        this.inputSubmitStart()

        this.$http.get('/reservation', {
            params: {
              location_id: this.form.location_id,
              pickup: this.form.pickup,
              drop_off: this.form.drop_off,
              vehicle_type: this.form.vehicle_type,
            },
          })
          .then(response => {
            this.summary = response.data
            this.form.errors.clear()
            this.inputSubmitFinish()
            this.transition_type = 'forward'
            this.current_step = 'rental-summary'
            this.errors = {}
          })
          .catch(error => {
            this.inputSubmitFinish()
            this.form.errors.record(error.response.data.errors)
            ErrorTransition(this.$el)
          })
      },
      newReservation() {
        this.transition_type = 'forward'
        this.current_step = 'rental-reserve'
      },
      createReservation() {
        this.inputSubmitStart()

        this.$http.post('/reservation', this.form.data())
          .then(response => {
            this.summary = response.data
            this.transition_type = 'forward'
            this.inputSubmitFinish()
            this.current_step = 'rental-confirmation'
            this.errors = {}
          })
          .catch(error => {
            this.inputSubmitFinish()
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
        form(@submit.prevent='viewRates()')
          .input-container.whole.mt-ex-sm
            .input-block
              label.input-label(for='location_id') Where:
              select.input-field#location_id(
                  v-model='form.location_id'
                  v-error='form.errors.has("location_id")'
                  @input='form.errors.clear("location_id")')
                option(value='1' disabled) Redlands, CA - Super 8 - 1160 Arizona St., Redlands, CA 92374
              input-error-message(:errors='form.errors.get("location_id")')

          .input-container.whole
            .input-container.one-half
              .input-block
                label.input-label(for='pickup') From:
                input-date-time(
                  v-model='form.pickup'
                  v-error='form.errors.has("pickup")'
                  @input='form.errors.clear("pickup")')
                input-error-message.input-message-lg(:errors='form.errors.get("pickup")')

            .input-container.one-half
              .input-block
                label.input-label(for='drop_off') To:
                input-date-time#drop_off(
                  v-model='form.drop_off'
                  v-error='form.errors.has("drop_off")'
                  @input='form.errors.clear("drop_off")')
                input-error-message.input-message-lg(:errors='form.errors.get("drop_off")')

            .input-container.whole
              .input-block
                label.input-label(for='vehicle_type') Vehicle Type
                input-vehicle-types.input-contrast(
                  v-model='form.vehicle_type'
                  v-error='form.errors.has("vehicle_type")'
                  @input='form.errors.clear("vehicle_type")')
                input-error-message(:errors='form.errors.get("vehicle_type")')

            .input-submit.input-block
              input-submit.btn.btn-full.btn-primary(:loading='input_submit_loading') View Rates

      #rental-summary(v-if="current_step == 'rental-summary'" key='summary')
        rental-invoice.input-block.mt-default(:summary='summary')

        .input-submit.input-flex-container
          .input-block.input-element-fixed
            button.btn(@click="current_step = 'rental-details', transition_type = 'backward'") Go Back
          .input-block.input-element-flex
            button.btn.btn-full.btn-primary(@click='newReservation') Reserve

      #rental-reserve(v-if="current_step == 'rental-reserve'" key='reserve')
        form(@submit.prevent='createReservation()')
          .input-container.whole.mt-ex-sm
            .input-block
              label.input-label(for='name_first') Name
            .input-container.one-half.fixed
              .input-block
                input.input-field#name_first(
                  type='text'
                  placeholder='Henry'
                  v-model='form.name_first'
                  v-error='form.errors.has("name_first")'
                  @input='form.errors.clear("name_first")')

                input-error-message.input-message-lg(:errors='form.errors.get("name_first")')

            .input-container.one-half.fixed
              .input-block
                input.input-field#name_last(
                  type='text'
                  placeholder='Ford'
                  v-model='form.name_last'
                  v-error='form.errors.has("name_last")'
                  @input='form.errors.clear("name_last")')

                input-error-message.input-message-lg(:errors='form.errors.get("name_last")')

          .input-container.whole
            .input-block
              label.input-label(for='input_email')
                | Email
                span.input-label-note.text-warning.right Valid email must be provided to confirm reservation.
              input.input-field#input_email(
                type='email'
                placeholder='hford@gmail.com'
                v-model='form.email'
                v-error='form.errors.has("email")'
                @input='form.errors.clear("email")')

              input-error-message.input-message-lg(:errors='form.errors.get("email")')

          .input-container.whole
            .input-block
              label.input-label(for='input_phone_number')
                | Phone #
                span.input-label-note.text-warning.right Valid number must be provided to confirm reservation.
              input.input-field#input_phone_number(
                type='number'
                placeholder='805-990-1234'
                v-model='form.phone_number'
                v-error='form.errors.has("phone_number")'
                @input='form.errors.clear("phone_number")')

              input-error-message.input-message-lg(:errors='form.errors.get("phone_number")')


          .input-submit.input-flex-container
            .input-block.input-element-fixed
              button.btn(@click.prevent="current_step = 'rental-summary', transition_type = 'backward'") Go Back
            .input-block.input-element-flex
              input-submit.btn.btn-full.btn-primary(:loading='input_submit_loading') Reserve Car

      #rental-confirmation(v-if="current_step == 'rental-confirmation'" key='confirmation')
        h2.emoji :]
        p.text-center Thanks for choosing us, {{ form.name_first }}!!! You should receive a email shortly summarizing your rental. Additionally, we will give you a call shortly to confirm your reservation.

        rental-invoice(:summary='summary')
</template>


<style lang='stylus'>
  @import '~Styles/global/colors'
  @import '~Styles/global/layout'

  #reservation-panel
    z-index: 2
    padding: 0 $padding-default
    background: #ffffff
    border-radius: 0.25rem
    border: 1px solid $border-color-light

  .input-field
    background-color: $background-color-contrast
    border-color: $border-color-input-contrast
</style>
