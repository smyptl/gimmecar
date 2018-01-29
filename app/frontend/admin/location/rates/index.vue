<script>
  import Form from 'Utils/form'
  import Shake from 'Utils/transitions/shake'

  import RentalInvoice from 'Admin/location/components/rental_invoice'
  import InputDateTime from 'Components/inputs/date_time'

  export default {
    name: 'rates',
    data () {
      return {
        rate_form: new Form({
          pickup: new Date(),
          drop_off: new Date().setDate(new Date().getDate() + 1),
          vehicle_type: '',
        }),
        summary: null,
      }
    },
    components: {
      RentalInvoice,
      InputDateTime,
    },
    methods: {
      getRates () {
        this.$http.post(this.$route.path, {
          rate: this.rate_form.data(),
        })
        .then(response => {
          this.rate_form.errors.clear
          this.summary = response.data
        })
        .catch(error => {
          Shake(this.$refs.form)
          this.rate_form.errors.record(error.response.data.errors)
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
    h3.panel-form-header Rates

    template(v-if='summary')
      rental-invoice.input-block.margin-top-sm(v-bind:summary='summary')

      .input-block.input-submit
        button.btn.left(@click.prevent='resetSummary()') Back

    template(v-else)
      .input-row
        .input-container.one-half
          label.input-label Pickup *
          .input-block.whole
            input-date-time(
              v-model='rate_form.pickup'
              v-error='rate_form.errors.has("pickup")'
              @input='rate_form.errors.clear("pickup")')
          input-error-message(v-bind:errors='rate_form.errors.get("pickup")')

        .input-container.one-half
          label.input-label Drop-off *
          .input-block.whole
            input-date-time(
              v-model='rate_form.drop_off'
              v-error='rate_form.errors.has("drop_off")'
              @input='rate_form.errors.clear("drop_off")')
          input-error-message(v-bind:errors='rate_form.errors.get("drop_off")')

      .input-row
        .input-container.whole
          label.input-label(for='vehicle_type') Vehicle Type *
          .input-block.whole
            select.input-field#vehicle_type(
              v-model='rate_form.vehicle_type'
              v-error='rate_form.errors.has("vehicle_type")'
              @input='rate_form.errors.clear("vehicle_type")')

              option(value='' disabled) -- Select Vehicle Type --
              option(value='subcompact') Subcompact (Toyota Yaris iA)
              option(value='compact') Compact (Toyota Corolla)
              option(value='mid_size') Mid-Size (Toyota Camry)
          input-error-message(v-bind:errors='rate_form.errors.get("vehicle_type")')

      .input-block.input-submit
        button.btn.btn-primary.right(@click.prevent='getRates') Continue


</template>
