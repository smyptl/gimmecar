<script>
  import Shake from 'Utils/transitions/shake'

  import InputDate from 'Components/inputs/date'
  import Popup from 'Components/popup'

  export default {
    data () {
      return {
        open: false,
        form: new this.$form({
          date: new Date(),
          days: 1,
          amount: '',
        }),
      }
    },
    mounted () {
      this.$http.get(this.$route.path + '/extend').then(response => {
        this.form.amount = response.data.last_rental_rate
      })

      this.open = true
    },
    components: {
      InputDate,
      Popup,
    },
    methods: {
      close () {
        this.$emit('close')
      },
      extendRental () {
        this.$http.post(this.$route.path + '/extend', {
          extend: this.form.data(),
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
    .panel-form-popup
      .panel-form.panel-form-padding
        h4.panel-form-popup-header Extend

      .panel-form.panel-form-padding.panel-popup-form-content
        input-error-message.mb-default.mt-default(v-bind:base='true' v-bind:errors='form.errors.get("base")')

        .input-row
          .input-container.two-fifths.fixed
            label.input-label(for='date') Date *
            .input-block.whole
              input-date#date(
                v-model='form.date'
                v-error='form.errors.has("date")'
                @input='form.errors.clear("date")')
            input-error-message(v-bind:errors='form.errors.get("date")')

          .input-container.one-fifth.fixed
            label.input-label(for='days') Days *
            .input-block.whole
              input.input-field#days(
                type='text'
                v-model='form.days'
                v-error='form.errors.has("days")'
                @input='form.errors.clear("days")')
            input-error-message(v-bind:errors='form.errors.get("days")')

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
          button.btn.btn-primary.right(@click.prevent='extendRental()') Extend
</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/form'
</style>
