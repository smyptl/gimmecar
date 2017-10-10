<script>
  import Form from 'Utils/form'

  import Find from 'lodash/find'
  import Currency from 'Filters/currency'

  import InputDate from 'Components/inputs/date'

  import Popup from 'Components/popup'

  export default {
    data () {
      return {
        open: false,
        form: new Form({
          amount: null,
          date: null,
          vehicle_type: null,
        })
      }
    },
    props: {
      date: {
        required: true,
      },
      rates: {
        required: true,
      }
    },
    components: {
      Popup,
      InputDate,
    },
    filters: {
      Currency,
    },
    computed: {
      vehicle_type () {
        return this.rates.vehicle_type
      },
      default_rate () {
        return this.rates.default_rate
      },
      is_default_rate () {
        return this.rate == this.default_rate
      },
      custom_rate () {
        let rate = Find(this.rates.rates, (r) => { return this.date.isSame(r.date, 'day') })

        if (rate) {
          return rate.amount
        }

        return null
      },
      rate () {
        return this.custom_rate || this.default_rate
      }
    },
    methods: {
      close () {
        this.open = false
        this.$emit('update')
      },
      editRate () {
        this.form.amount = this.rate
        this.form.vehicle_type = this.vehicle_type
        this.form.date = this.date

        this.open = true
        return
      },
      updateRate () {
        this.$http.post(this.$route.path, {
          edit: this.form.data(),
        })
        .then(response => {
          this.form.errors.clear
          this.close()
        })
        .catch(error => {
          this.form.errors.record(error.response.data.errors)
        })
      }
    },
  }
</script>

<template lang='pug'>
  td.text-right.clickable
    span(@click='editRate' v-bind:class="{ 'text-light': is_default_rate }") {{ rate | currency }}

    popup(v-if='open' @closed='close')
      .panel-form-popup
        .panel-form.panel-form-padding
          h4.panel-form-popup-header Rate - {{ vehicle_type }}

        .panel-form.panel-form-padding.panel-popup-form-content
          .input-row
            .input-container.one-half.fixed
              label.input-label(for='date') Date
              .input-block.whole
                input-date#date(
                  v-model='form.date'
                  v-error='form.errors.has("date")'
                  @input='form.errors.clear("date")')
              input-error-message(v-bind:errors='form.errors.get("date")')


            .input-container.one-half.fixed
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
            button.btn.btn-primary.right(@click.prevent='updateRate()') Update
</template>

<style lang='stylus' scoped>
  td
    position: relative

</style>
