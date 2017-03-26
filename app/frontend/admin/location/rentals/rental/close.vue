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
          drop_off_date: new Date(),
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
        console.log('close')
        this.$emit('close')
      },
      closeRental () {
      },
    },
  }
</script>

<template lang='pug'>
  popup(v-if='open' v-on:close='close')
    .panel-popup-form
      .panel-form.panel-form-padding
        h3.panel-form-header Close - #12312313

        .input-row
          label.input-label(for='drop_off_date') Drop Off
          .input-block.whole
            input-date-time.input-field.input-contrast#drop_off_date(v-model='form.drop_off_date')

        .input-row
          .input-container.two-fifths
            label.input-label(for='drop_off_odometer') Vehicle Odometer
            .input-block.whole
              input.input-field.input-contrast#drop_off_odometer(type='text' v-model='form.drop_off_odometer')

          .input-container.three-fifths
            label.input-label(for='drop_off_fuel')
              | Fuel Level
              .input-label-note.right {{ form.drop_off_fuel * 10 }}%
            .input-block.whole
              input.input-range#drop_off_fuel(type='range' v-model.number='form.drop_off_fuel' min='0' max='10')

        .input-submit.input-block
          button.btn.btn-primary.right(@click.prevent='closeRental()') Continue
</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/form'
</style>
