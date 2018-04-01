<script>
  import Shake from 'Utils/transitions/shake'

  import InputDate from 'Components/inputs/date'
  import Submit from 'Components/inputs/submit'
  import Popup from 'Components/popup'

  export default {
    props: {
      url: {
        type: String,
        required: true,
      }
    },
    data () {
      return {
        open: false,
        form: new this.$form({
          amount: '',
        }),
        loading_button: false,
      }
    },
    mounted () {
      this.$http.get(this.url).then(response => {
        this.form.amount = response.data.deposit_amount
      })

      this.open = true
    },
    components: {
      Submit,
      Popup,
    },
    methods: {
      close () {
        this.$emit('close')
      },
      returnDeposit () {
        this.loading_button = true

        this.$http.post(this.url, {
          return_deposit: this.form.data(),
        })
        .then(response => {
          this.form.errors.clear
          this.close()
        })
        .catch(error => {
          this.form.errors.record(error.response.data.errors)
          this.loading_button = false
        })
      },
    },
  }
</script>

<template lang='pug'>
  popup(v-if='open' v-on:closed='close')
    .panel-form-popup
      .panel-form.panel-form-padding
        h4.panel-form-popup-header Return Deposit

      .panel-form.panel-form-padding.panel-popup-form-content
        .input-block.mt-default.mb-sm(v-if='form.errors.has("base")')
          input-error-message(v-bind:base='true' v-bind:errors='form.errors.get("base")')

          .input-container.two-fifths.fixed
            label.input-label(for='amount') Amount
            .input-block.whole
              input.input-field#amount(
                type='text'
                v-model='form.amount'
                v-error='form.errors.has("amount")'
                @input='form.errors.clear("amount")')
            input-error-message(v-bind:errors='form.errors.get("amount")')

      .panel-form.panel-form-padding.panel-popup-form-footer
        .input-submit.input-block
          submit.btn.btn-primary.right(@click.native.prevent='extendRental()' :loading='loading_button') Return
</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/form'
</style>
