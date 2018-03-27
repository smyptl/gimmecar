<script>
  import Shake from 'Utils/transitions/shake'

  import Payment from 'Components/inputs/payment'
  import Popup from 'Components/popup'

  export default {
    data () {
      return {
        open: false,
        form: new this.$form({
          token: '',
        }),
      }
    },
    mounted () {
      this.open = true
    },
    components: {
      Payment,
      Popup,
    },
    methods: {
      close () {
        this.$emit('close')
      },
      addtoken () {
        stripe.createToken(window.card).then(result => {
          if (result.error) {
            this.form.errors.record({ token: [result.error.message] })
            this.disabled_button = false
          } else {
            this.form.errors.clear
            // Send the token to your server
            this.form.token = result.token.id

            this.$http.post(this.$route.path + '/add-card', this.form.data())
              .then(response => {
                this.form.errors.clear
                this.close()
              })
              .catch(error => {
                this.form.errors.record(error.response.data.errors)
              })
          }
        });
      },
    },
  }
</script>

<template lang='pug'>
  popup(v-if='open' v-on:closed='close')
    .panel-form-popup
      .panel-form.panel-form-padding
        h4.panel-form-popup-header Add Card

      .panel-form.panel-form-padding.panel-popup-form-content
        .input-row
          label.input-label
            | Card Number
            .input-label-note.right DO NOT accept prepaid cards.
          .input-block.whole
            payment(v-error='form.errors.has("token")' @click='form.errors.clear("token")')
          input-error-message(v-bind:errors='form.errors.get("token")')

      .panel-form.panel-form-padding.panel-popup-form-footer
        .input-submit.input-block
          button.btn.btn-primary.right(@click.prevent='addtoken()') Add
</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/form'
</style>
