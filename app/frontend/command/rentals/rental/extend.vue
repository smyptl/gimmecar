<script>
  import Shake from 'Utils/transitions/shake'

  import InputSubmit from 'Mixins/input_submit'

  import InputCurrency       from 'Components/inputs/currency'
  import InputDate           from 'Components/inputs/date'
  import InputPaymentSources from 'Components/inputs/payment_sources'
  import Popup               from 'Components/popup'

  export default {
    name: 'RentalExtend',
    props: {
      url: {
        type: String,
        required: true
      }
    },
    data() {
      return {
        open: false,
        rental: {},
        form: new this.$form({
          date: '',
          days: 1,
          amount: '',
          source: {
            customer_id: '',
            source_id: '',
          },
        }),
      }
    },
    mixins: [
      InputSubmit,
    ],
    components: {
      InputCurrency,
      InputDate,
      InputPaymentSources,
      Popup,
    },
    mounted() {
      this.$http.get(this.url).then(response => {
        this.rental = response.data;
        this.form.amount = this.rental.rental_last_rate_amount;
        this.form.date   = this.rental.drop_off;

        this.open = true
      })
    },
    methods: {
      close() {
        this.$emit('close')
      },
      extendRental() {
        this.inputSubmitStart()

        this.$http.post(this.url, this.form.data())
          .then(response => {
            this.form.errors.clear()
            this.inputSubmitFinish()
            this.close()
          })
          .catch(error => {
            this.form.errors.record(error.response.data.errors)
            this.inputSubmitFinish()
          })
      },
    },
  }
</script>

<template lang='pug'>
  popup(v-if='open' @closed='close')
    .panel-form-popup
      .panel-form.panel-form-padding
        h4.panel-form-popup-header Extend

      .panel-form.panel-form-padding.panel-popup-form-content
        .input-block.mt-default.mb-sm(v-if='form.errors.has("base")')
            input-error-message(:base='true' :errors='form.errors.get("base")')

        .input-container.whole
          .input-container.two-fifths.fixed
            .input-block
              label.input-label(for='date') Date
              input-date#date(
                v-model='form.date'
                v-error='form.errors.has("date")'
                @input='form.errors.clear("date")')
              input-error-message(:errors='form.errors.get("date")')

          .input-container.one-fifth.fixed
            .input-block
              label.input-label(for='days') Days
              input.input-field#days(
                type='text'
                v-model='form.days'
                v-error='form.errors.has("days")'
                @input='form.errors.clear("days")')
              input-error-message(:errors='form.errors.get("days")')

          .input-container.two-fifths.fixed
            .input-block
              label.input-label(for='amount') Amount
              input-currency#amount(
                v-model='form.amount'
                v-error='form.errors.has("amount")'
                @input='form.errors.clear("amount")')
              input-error-message(:errors='form.errors.get("amount")')

        .input-container.whole
          .input-block
            label.input-label Payment
            input-payment-sources(
              v-model='form.source'
              v-error='form.errors.has("source_source_id")'
              :error='form.errors.has("source_source_id")'
              :sources='rental'
              @input='form.errors.clear("source_source_id")')
            input-error-message(:errors='form.errors.get("source_source_id")')

      .panel-form.panel-form-padding.panel-popup-form-footer
        .input-submit.input-block
          input-submit.btn.btn-primary.right(@click.native.prevent='extendRental()' :loading='input_submit_loading') Extend
</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/form'
</style>
