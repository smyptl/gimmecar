<script>
  import Shake from 'Utils/transitions/shake'

  import InputSubmit from 'Mixins/input_submit'

  import InputDate from 'Components/inputs/date'
  import InputFile from 'Components/inputs/file'
  import Popup from 'Components/popup'

  export default {
    name: 'VehicleAddRegistration',
    props: {
      url: {
        type: String,
        required: true
      }
    },
    data() {
      return {
        open: false,
        form: new this.$form({
          date_effective:  '',
          date_expiration: '',
          registration:    '',
          notes:           '',
        }),
      }
    },
    mixins: [
      InputSubmit,
    ],
    components: {
      InputDate,
      InputFile,
      Popup,
    },
    mounted() {
      this.open = true
    },
    methods: {
      close() {
        this.$emit('close')
      },
      addRegistration() {
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
        h4.panel-form-popup-header Add Registration

      .panel-form.panel-form-padding.panel-popup-form-content
        .input-container.whole
          .input-container.one-half.fixed
            .input-block
              label.input-label(for='date_effective') Effective Date
              input-date#date_effective(
                v-model='form.date_effective'
                v-error='form.errors.has("date_effective")'
                @input='form.errors.clear("date_effective")')
              input-error-message(:errors='form.errors.get("date_effective")')

          .input-container.one-half.fixed
            .input-block
              label.input-label(for='date_expiration') Expiration Date
              input-date#date_expiration(
                v-model='form.date_expiration'
                v-error='form.errors.has("date_expiration")'
                @input='form.errors.clear("date_expiration")')
              input-error-message(:errors='form.errors.get("date_expiration")')

        .input-container.whole
          .input-block
            label.input-label(for='registration') Registration
            input-file#registration(
              v-model='form.registration'
              v-error='form.errors.has("registration")'
              @input='form.errors.clear("registration")')
            input-error-message(:errors='form.errors.get("registration")')

      .panel-form.panel-form-padding.panel-popup-form-footer
        .input-submit.input-block
          input-submit.btn.btn-primary.right(@click.native.prevent='addRegistration()' :loading='input_submit_loading') Add
</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/form'
</style>
