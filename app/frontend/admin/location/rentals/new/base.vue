<script>
  import Capitalize from 'lodash/capitalize'

  import Form from 'Utils/form'
  import Shake from 'Utils/transitions/shake'

  import Rates from 'Admin/location/quotes/summary'
  import Driver from 'Admin/location/components/driver'

  import InputDateTime from 'Components/inputs/date_time'
  import Signature from 'Components/inputs/signature'


  export default {
    name: 'new',
    data () {
      return {
        rental: new Form({
          pickup: new Date(),
          drop_off: new Date().setDate(new Date().getDate() + 1),
          vehicle_id: null,
          driver_id: null,
          driver: {
            first_name: '',
            last_name: '',
            license_number: '',
            license_state: '',
            license_country: '',
            license_expiration_date: '',
            address_1: '',
            address_2: '',
            city: '',
            state: '',
            zip_code: '',
            country: '',
            gender: '',
            date_of_birth: '',
            cell_phone_number: '',
            home_phone_number: '',
            signature: '',
          },
          add_additional_driver: false,
          additional_driver_id: null,
          additional_driver: {
            first_name: '',
            last_name: '',
            license_number: '',
            license_state: '',
            license_country: '',
            license_expiration_date: '',
            address_1: '',
            address_2: '',
            city: '',
            state: '',
            zip_code: '',
            country: '',
            gender: '',
            date_of_birth: '',
            cell_phone_number: '',
            home_phone_number: '',
            signature: '',
          },
          pickup_odometer: '',
          pickup_fuel: '',
          card_selected: '',
          stripe_token: '',
        }),
        current_step: 'details',
        vehicles: [],
        summary: {},
      }
    },
    components: {
      Rates,
      Driver,
      InputDateTime,
      Signature,
    },
    filters: {
      Capitalize,
    },
    computed: {
      steps () {
        return [
          'details',
          'rates',
          'drivers',
          'vehicle',
          'sign',
          'payment',
        ]
      },
      number_of_steps () {
        return this.steps.length
      },
      current_step_number () {
        return this.steps.indexOf(this.current_step) + 1
      },
    },
    methods: {
      nextStep () {
        this.current_step = this.steps[this.steps.indexOf(this.current_step) + 1]
      },
      goBack () {
        this.current_step = this.steps[this.steps.indexOf(this.current_step) - 1]
      },
      getRates () {
        this.$http.post(this.$route.path + '/rates', {
          rental: this.rental.data(),
        })
        .then(response => {
          this.rental.errors.clear
          this.summary = response.data
          this.nextStep()
        })
        .catch(error => {
          Shake(this.$refs.form)
          this.rental.errors.record(error.response.data.errors)
        })
      },
      getVehicles () {
        this.$http.post(this.$route.path + '/vehicles', {
          rental: this.rental.data(),
        })
        .then(response => {
          this.vehicles = response.data
          this.nextStep()
        })
        .catch(error => {
        })
      },
      validateDrivers () {
        this.$http.post(this.$route.path + '/drivers', {
          rental: this.rental.data(),
        })
        .then(response => {
          this.rental.errors.clear
          this.summary = response.data
          this.nextStep()
        })
        .catch(error => {
          Shake(this.$refs.form)
          this.rental.errors.record(error.response.data.errors)
        })
      },
    },
  }

</script>

<template lang='pug'>
  .form-container
    h4.form-header.form-header-first(ref='form')
      | Rental: {{ current_step | capitalize }}
      small.right {{ current_step_number }} of {{ number_of_steps }}

    template(v-if='current_step == "details"')
      .input-row
        .input-container.one-half
          label.input-label From:
          .input-block.whole
            input-date-time(
              v-model='rental.pickup'
              v-error='rental.errors.has("pickup")'
              @input='rental.errors.clear("pickup")')
          input-error-message(field='pickup' v-bind:errors='rental.errors.get("pickup")')

        .input-container.one-half
          label.input-label To:
          .input-block.whole
            input-date-time(
              v-model='rental.drop_off'
              v-error='rental.errors.has("drop_off")'
              @input='rental.errors.clear("drop_off")')
          input-error-message(field='drop_off' v-bind:errors='rental.errors.get("drop_off")')

      .input-submit.input-block
        button.btn.btn-primary.right(@click.prevent='getRates()') Continue

    template(v-if='current_step == "rates"')
      rates(v-bind:summary='summary')

      .input-submit.input-block
        button.btn.left(@click.prevent='goBack()') Go Back
        button.btn.btn-primary.right(@click.prevent='nextStep()') Continue

    template(v-if='current_step == "drivers"')
      driver(v-bind:form='rental')

      .input-submit.input-block
        button.btn.left(@click.prevent='goBack()') Go Back
        button.btn.btn-primary.right(@click.prevent='getVehicles()') Continue

    template(v-if='current_step == "vehicle"')
      h1 {{ vehicles }}

      .input-submit.input-block
        button.btn.left(@click.prevent='goBack()') Go Back
        button.btn.btn-primary.right(@click.prevent='nextStep()') Continue

    template(v-if='current_step == "sign"')
      h6.input-label {{ rental.driver.first_name }} {{ rental.driver.last_name }}
      .input-block.whole
        signature(v-model='rental.driver.signature')

      template(v-if='rental.add_additional_driver')
        h6.input-label.margin-top-default {{ rental.additional_driver.first_name }} {{ rental.additional_driver.last_name }}
        .input-block.whole
          signature(v-model='rental.additional_driver.signature')

      .input-block.input-submit
        button.btn.left(@click.prevent='goBack()') Go Back
        button.btn.btn-primary.right(@click.prevent='nextStep()') Continue


    template(v-if='current_step == "payment"')
      .input-row
        .input-container.two-fifths
          label.input-label Card Number
          .input-block.whole
            input.input-field(type='number' size='20' data-stripe="number" placeholder='4242 4242 4242 4242')
        .input-container.three-fifths
          .input-container.one-third.fixed
            label.input-label Expiration Date
            .input-block.one-half.fixed
              input.input-field(type='number' size='2' data-stripe="exp_month" placeholder='MM')
            .input-block.one-half.fixed
              input.input-field(type='number' size='2' data-stripe="exp_year" placeholder='YY')
          .input-container.one-third.fixed
          .input-container.one-third.fixed
            label.input-label CVC
            .input-block.whole
              input.input-field(type='number' size='4' data-stripe="cvc" placeholder='123')
          .input-container.one-third.fixed
            label.input-label Zip Code
            .input-block.whole
              input.input-field(type='number' size='6' data-stripe="address_zip" placeholder='90210')

      .input-block.input-submit
        button.btn.left(@click.prevent='goBack()') Go Back
        button.btn.btn-primary.right(@click.prevent='nextStep()') Continue

</template>

<style lang='stylus' scoped>
</style>
