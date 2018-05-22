<script>
  import Shake from 'Utils/transitions/shake'

  import InputVehicleTypes from 'Components/inputs/vehicle_types'
  import InputSubmit       from 'Mixins/input_submit'

  import RentalInvoice from 'Components/quote'
  import InputDateTime from 'Components/inputs/date_time'

  export default {
    name: 'Quote',
    data() {
      return {
        form: new this.$form({
          pickup: new Date(),
          drop_off: new Date().setDate(new Date().getDate() + 1),
          vehicle_type: '',
        }),
        summary: null,
      }
    },
    mixins: [
      InputSubmit,
    ],
    components: {
      InputDateTime,
      InputVehicleTypes,
      RentalInvoice,
    },
    methods: {
      getQuote() {
        this.inputSubmitStart()

        this.$http.post(this.$route.path, this.form.data())
          .then(response => {
            this.form.errors.clear
            this.inputSubmitFinish()
            this.summary = response.data
          })
          .catch(error => {
            Shake(this.$refs.form)
            this.inputSubmitFinish()
            this.form.errors.record(error.response.data.errors)
          })
      },
      resetSummary() {
        this.summary = null
      },
    },
  }
</script>

<template lang='pug'>
  .panel-form(ref='form')
    h3.panel-form-header Quote

    template(v-if='summary')
      rental-invoice.input-block.mt-sm(:summary='summary')

      .input-block.input-submit
        button.btn.left(@click.prevent='resetSummary()') Back

    template(v-else)
      .input-container.whole
        .input-container.one-half
          .input-block
            label.input-label Pickup
            input-date-time(
              v-model='form.pickup'
              v-error='form.errors.has("pickup")'
              @input='form.errors.clear("pickup")')
            input-error-message(:errors='form.errors.get("pickup")')

        .input-container.one-half
          .input-block
            label.input-label Drop-off
            input-date-time(
              v-model='form.drop_off'
              v-error='form.errors.has("drop_off")'
              @input='form.errors.clear("drop_off")')
            input-error-message(:errors='form.errors.get("drop_off")')

      .input-container.whole
        .input-container.whole
          .input-block
            label.input-label(for='vehicle_type') Vehicle Type
            input-vehicle-types(
              v-model='form.vehicle_type'
              v-error='form.errors.has("vehicle_type")'
              @input='form.errors.clear("vehicle_type")')
            input-error-message(:errors='form.errors.get("vehicle_type")')

      .input-block.input-submit
        input-submit.btn.btn-primary.right(@click.native.prevent='getQuote()' :loading='input_submit_loading') Continue

</template>
