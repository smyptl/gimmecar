<script>
  import Shake from 'Utils/transitions/shake'

  import InputSubmit from 'Mixins/input_submit'

  import RentalInvoice from 'Components/quote'
  import InputDateTime from 'Components/inputs/date_time'

  export default {
    name: 'Quote',
    data() {
      return {
        quote: new this.$form({
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
      RentalInvoice,
    },
    methods: {
      getQuote() {
        this.inputSubmitStart()

        this.$http.post(this.$route.path, this.quote.data())
          .then(response => {
            this.quote.errors.clear
            this.inputSubmitFinish()
            this.summary = response.data
          })
          .catch(error => {
            Shake(this.$refs.form)
            this.inputSubmitFinish()
            this.quote.errors.record(error.response.data.errors)
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
      rental-invoice.input-block.mt-sm(v-bind:summary='summary')

      .input-block.input-submit
        button.btn.left(@click.prevent='resetSummary()') Back

    template(v-else)
      .input-row
        .input-container.one-half
          label.input-label Pickup *
          .input-block.whole
            input-date-time(
              v-model='quote.pickup'
              v-error='quote.errors.has("pickup")'
              @input='quote.errors.clear("pickup")')
          input-error-message(v-bind:errors='quote.errors.get("pickup")')

        .input-container.one-half
          label.input-label Drop-off *
          .input-block.whole
            input-date-time(
              v-model='quote.drop_off'
              v-error='quote.errors.has("drop_off")'
              @input='quote.errors.clear("drop_off")')
          input-error-message(v-bind:errors='quote.errors.get("drop_off")')

      .input-row
        .input-container.whole
          label.input-label(for='vehicle_type') Vehicle Type *
          .input-block.whole
            select.input-field#vehicle_type(
              v-model='quote.vehicle_type'
              v-error='quote.errors.has("vehicle_type")'
              @input='quote.errors.clear("vehicle_type")')

              option(value='' disabled) --
              option(value='subcompact') Subcompact (Toyota Yaris iA)
              option(value='compact') Compact (Toyota Corolla)
              option(value='mid_size') Mid-Size (Toyota Camry)
          input-error-message(v-bind:errors='quote.errors.get("vehicle_type")')

      .input-block.input-submit
        input-submit.btn.btn-primary.right(@click.native.prevent='getQuote' :loading='input_submit_loading') Continue

</template>
