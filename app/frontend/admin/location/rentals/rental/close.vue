<script>
  import Form from 'Utils/form'
  import Shake from 'Utils/transitions/shake'

  import InputDateTime from 'Components/inputs/date_time'

  import Popup from 'Components/popup'

  export default {
    data () {
      return {
        open: false,
        form: new Form({
          drop_off: new Date(),
          drop_off_fuel: 10,
          drop_off_odometer: '',
        })
      }
    },
    mounted () {
      this.open = true
    },
    components: {
      Popup,
      InputDateTime,
    },
    methods: {
      close () {
        this.$emit('close')
      },
      closeRental () {
        this.$http.post(this.$route.path + '/close', {
          close: this.form.data(),
        })
        .then(response => {
          this.form.errors.clear
          this.close()
        })
        .catch(error => {
          this.form.errors.record(error.response.data.errors)
        })
      },
    },
  }
</script>

<template lang='pug'>
  popup(v-if='open' v-on:closed='close')
    .panel-popup-form
      .panel-form.panel-form-padding
        h3.panel-form-header Close - #12312313

        .input-row
          label.input-label(for='drop_off') Drop Off *
          .input-block.whole
            input-date-time.input-contrast#drop_off(
              v-model='form.drop_off'
              v-error='form.errors.has("drop_off")'
              @input='form.errors.clear("drop_off")')
          input-error-message(v-bind:errors='form.errors.get("drop_off")')

        .input-row
          .input-container.two-fifths
            label.input-label(for='drop_off_odometer') Vehicle Odometer *
            .input-block.whole
              input.input-field.input-contrast#drop_off_odometer(
                type='text'
                v-model='form.drop_off_odometer'
                v-error='form.errors.has("drop_off_odometer")'
                @input='form.errors.clear("drop_off_odometer")')
            input-error-message(v-bind:errors='form.errors.get("drop_off_odometer")')

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
            input-error-message(v-bind:errors='form.errors.get("drop_off_fuel")')

        .input-submit.input-block
          button.btn.btn-primary.right(@click.prevent='closeRental()') Close
</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/form'
</style>
