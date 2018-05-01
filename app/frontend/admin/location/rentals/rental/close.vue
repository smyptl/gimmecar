<script>
  import Shake from 'Utils/transitions/shake'

  import InputSubmit from 'Mixins/input_submit'

  import InputDateTime from 'Components/inputs/date_time'
  import Popup from 'Components/popup'

  export default {
    name: 'RentalClose',
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
          drop_off: new Date(),
          drop_off_fuel: 10,
          drop_off_odometer: '',
        })
      }
    },
    mixins: [
      InputSubmit,
    ],
    components: {
      InputDateTime,
      Popup,
    },
    mounted() {
      this.open = true
    },
    methods: {
      close() {
        this.$emit('close')
      },
      closeRental() {
        this.inputSubmitStart()

        this.$http.post(this.url, this.form.data())
          .then(response => {
            this.form.errors.clear
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
        h4.panel-form-popup-header Close

      .panel-form.panel-form-padding.panel-popup-form-content
        .input-row
          label.input-label(for='drop_off') Drop Off *
          .input-block.whole
            input-date-time#drop_off(
              v-model='form.drop_off'
              v-error='form.errors.has("drop_off")'
              @input='form.errors.clear("drop_off")')
          input-error-message(:errors='form.errors.get("drop_off")')

        .input-row
          .input-container.two-fifths
            label.input-label(for='drop_off_odometer') Vehicle Odometer *
            .input-block.whole
              input.input-field#drop_off_odometer(
                type='text'
                v-model='form.drop_off_odometer'
                v-error='form.errors.has("drop_off_odometer")'
                @input='form.errors.clear("drop_off_odometer")')
            input-error-message(:errors='form.errors.get("drop_off_odometer")')

          .input-container.three-fifths
            label.input-label(for='drop_off_fuel')
              | Fuel Level *
              .input-label-note.right {{ form.drop_off_fuel * 10 }}%
            .input-block.whole
              input.input-range#drop_off_fuel(
                type='range'
                v-model.number='form.drop_off_fuel'
                min='0'
                max='10'
                v-error='form.errors.has("drop_off_fuel")'
                @input='form.errors.clear("drop_off_fuel")')
            input-error-message(:errors='form.errors.get("drop_off_fuel")')


      .panel-form.panel-form-padding.panel-popup-form-footer
        .input-submit.input-block
          input-submit.btn.btn-primary.right(@click.native.prevent='closeRental()' :loading='input_submit_loading') Close
</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/form'
</style>
