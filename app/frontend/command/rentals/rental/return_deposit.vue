<script>
  import Shake from 'Utils/transitions/shake'

  import InputSubmit from 'Mixins/input_submit'

  import InputDate from 'Components/inputs/date'
  import Popup     from 'Components/popup'

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
      }
    },
    mixins: [
      InputSubmit,
    ],
    components: {
      Popup,
    },
    mounted () {
      this.$http.get(this.url).then(response => {
        this.form.amount = response.data.deposit_amount
      })

      this.open = true
    },
    methods: {
      close () {
        this.$emit('close')
      },
      returnDeposit () {
        this.inputSubmitStart()

        this.$http.post(this.url, {
          return_deposit: this.form.data(),
        })
        .then(response => {
          this.form.errors.clear
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
  popup(v-if='open' v-on:closed='close')
    .panel-form-popup
      .panel-form.panel-form-padding
        h4.panel-form-popup-header Return Deposit

      .panel-form.panel-form-padding.panel-popup-form-content
        .input-container.whole
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
          input-submit.btn.btn-primary.right(@click.native.prevent='returnDeposit()' :loading='input_submit_loading') Return
</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/form'
</style>
