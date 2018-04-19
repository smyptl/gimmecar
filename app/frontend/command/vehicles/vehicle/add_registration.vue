<script>
  import Shake from 'Utils/transitions/shake'

  import InputSubmit from 'Mixins/input_submit'

  import InputDate from 'Components/inputs/date'
  import Popup from 'Components/popup'

  export default {
    name: 'VehicleAddRegistration',
    props: {
      url: {
        type: String,
        required: true
      }
    },
    data () {
      return {
        open: false,
        form: new this.$form({
          date_effective: null,
          date_expiration: null,
          registration: null,
          notes: null,
        }),
      }
    },
    mixins: [
      InputSubmit,
    ],
    components: {
      InputDate,
      Popup,
    },
    mounted () {
      this.open = true
    },
    methods: {
      close () {
        this.$emit('close')
      },
      addRegistration () {
        this.inputSubmitStart()

        this.$http.post(this.url, {
          extend: this.form.data(),
        })
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
        .input-row
          .input-container.one-half.fixed
            label.input-label(for='date_effective') Effective Date *
            .input-block.whole
              input-date#date_effective(
                v-model='form.date'
                v-error='form.errors.has("date_effective")'
                @input='form.errors.clear("date_effective")')
            input-error-message(v-bind:errors='form.errors.get("date_effective")')

          .input-container.one-half.fixed
            label.input-label(for='date_expiration') Expiration Date *
            .input-block.whole
              input-date#date_expiration(
                v-model='form.date'
                v-error='form.errors.has("date_expiration")'
                @input='form.errors.clear("date_expiration")')
            input-error-message(v-bind:errors='form.errors.get("date_expiration")')

        .input-row
          label.input-label(for='registration') Registration *
          .input-block.whole
            input(type='file' name='registration')

      .panel-form.panel-form-padding.panel-popup-form-footer
        .input-submit.input-block
          input-submit.btn.btn-primary.right(@click.native.prevent='addRegistration()' :loading='input_submit_loading') Add
</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/form'
</style>
