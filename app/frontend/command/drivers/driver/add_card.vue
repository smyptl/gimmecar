<script>
  import Shake from 'Utils/transitions/shake'

  import InputSubmit from 'Mixins/input_submit'

  import Payment from 'Components/inputs/payment'
  import Popup from 'Components/popup'

  export default {
    name: 'AddCard',
    props: {
      url: {
        type: String,
        required: true,
      }
    },
    data() {
      return {
        open: false,
        form: new this.$form({
          token: '',
        }),
      }
    },
    mixins: [
      InputSubmit,
    ],
    components: {
      Payment,
      Popup,
    },
    mounted() {
      this.open = true
    },
    methods: {
      close() {
        this.$emit('close')
      },
      addToken() {
        this.inputSubmitStart()

        stripe.createToken(window.card).then(result => {
          if (result.error) {
            this.inputSubmitFinish()
            this.form.errors.record({ token: [result.error.message] })
          } else {
            this.form.errors.clear

            // Send the token to your server
            this.form.token = result.token.id

            this.$http.post(this.url, this.form.data())
              .then(response => {
                this.form.errors.clear
                this.close()
              })
              .catch(error => {
                this.form.errors.record(error.response.data.errors)
                this.inputSubmitFinish()
              })
          }
        });
      },
    },
  }
</script>

<template lang='pug'>
  popup(v-if='open' @closed='close')
    .panel-form-popup
      .panel-form.panel-form-padding
        h4.panel-form-popup-header Add Card
        
      form(@submit.prevent='addToken()')
        .panel-form.panel-form-padding.panel-popup-form-content
          .input-container.whole
            .input-block
              label.input-label
                | Card Number
                .input-label-note.right DO NOT accept prepaid cards.
              payment(
                @add-error='form.errors.record({ token: [$event] })'
                @clear-error='form.errors.clear()'
                v-error='form.errors.has("token")')
              input-error-message(:errors='form.errors.get("token")')

        .panel-form.panel-form-padding.panel-popup-form-footer
          .input-submit.input-block
            input-submit.btn.btn-primary.right(:loading='input_submit_loading') Add
</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/form'
</style>
