<script>
  import Shake from 'Utils/transitions/shake'

  import InputSubmit from 'Mixins/input_submit'

  import RentalInvoice     from 'Components/quote'
  import InputVehicleTypes from 'Components/inputs/vehicle_types'
  import InputDateTime     from 'Components/inputs/date_time'

  export default {
    name: 'Quote',
    data() {
      return {
        form: new this.$form({
          location_id: '',
          pickup: new Date(),
          drop_off: new Date().setDate(new Date().getDate() + 1),
          vehicle_type: '',
        }),
        locations: {},
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
    created() {
      this.getLocations()
    },
    methods: {
      getLocations() {
        this.$http
          .get(this.$route.path)
          .then(response => {
            this.locations = response.data
        })
      },
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
      .input-row
        label.input-label(for='location_id') Location *
        .input-block.whole
          select.input-field#location_id(
            v-model='form.location_id'
            v-error='form.errors.has("location_id")'
            @input='form.errors.clear("location_id")')

            option(value='') --
            option(v-for='location in locations.data' :key='location.id' :value='location.id') {{ location.name }} -- {{ location.city }}, {{ location.state }}
        input-error-message(:errors='form.errors.get("location_id")')

      .input-row
        .input-container.one-half
          label.input-label Pickup *
          .input-block.whole
            input-date-time(
              v-model='form.pickup'
              v-error='form.errors.has("pickup")'
              @input='form.errors.clear("pickup")')
          input-error-message(:errors='form.errors.get("pickup")')

        .input-container.one-half
          label.input-label Drop-off *
          .input-block.whole
            input-date-time(
              v-model='form.drop_off'
              v-error='form.errors.has("drop_off")'
              @input='form.errors.clear("drop_off")')
          input-error-message(:errors='form.errors.get("drop_off")')

      .input-row
        .input-container.whole
          label.input-label(for='vehicle_type') Vehicle Type *
          .input-block.whole
            input-vehicle-types(
              v-model='form.vehicle_type'
              v-error='form.errors.has("vehicle_type")'
              @input='form.errors.clear("vehicle_type")')
          input-error-message(:errors='form.errors.get("vehicle_type")')

      .input-block.input-submit
        input-submit.btn.btn-primary.right(@click.native.prevent='getQuote' :loading='input_submit_loading') Continue
</template>
