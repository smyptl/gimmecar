<script>
  import Form from 'Utils/form'
  import Shake from 'Utils/transitions/shake'

  import Rates from 'Admin/location/quotes/summary'
  import Driver from 'Admin/location/components/driver'

  import InputDateTime from 'Components/inputs/date_time'


  export default {
    name: 'new',
    data () {
      return {
        rental: new Form({
          pickup: new Date(),
          drop_off: new Date().setDate(new Date().getDate() + 1),
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
          },
          add_additional_driver: false,
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
          },
        }),
        step: 'rates',
        summary: {},
      }
    },
    components: {
      Rates,
      Driver,
      InputDateTime,
    },
    methods: {
      getRates () {
        this.$http.post(this.$route.path + '/rates', {
          rental: this.rental.data(),
        })
        .then(response => {
          this.rental.errors.clear
          this.summary = response.data
          this.step = 'summary'
        })
        .catch(error => {
          Shake(document.getElementById('rental-form'))
          this.rental.errors.record(error.response.data.errors)
        })
      },
      validateDrivers () {
        this.$http.post(this.$route.path + '/drivers', {
          rental: this.rental.data(),
        })
        .then(response => {
          this.rental.errors.clear
          this.summary = response.data
          this.step = 'add-ons'
        })
        .catch(error => {
          Shake(document.getElementById('rental-form'))
          this.rental.errors.record(error.response.data.errors)
        })
      },
    },
  }

</script>

<template lang='pug'>
  .form-container
    #rental-form(v-if='step == "rates"')
      h4.form-header.form-header-first
        | Rental: Details
        small.right 1 of 10
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
        button.btn.btn-primary.right(@click.prevent='getRates()') Rates

    template(v-if='step == "summary"')
      h4.form-header.form-header-first
        | Rental: Rates
        small.right 2 of 10
      rates(v-bind:summary='summary')

      .input-submit.whole
        button.btn.left(@click="step = 'rates', transition_type = 'backward'") Go Back
        button.btn.btn-primary.right(@click.prevent='step = "driver"') Continue

    template(v-if='step == "driver"')
      h4.form-header.form-header-first
        | Rental: Driver
        small.right 3 of 10

      driver(v-bind:form='rental')

      .input-submit.whole
        button.btn.left(@click="step = 'summary', transition_type = 'backward'") Go Back
        button.btn.btn-primary.right(@click.prevent='step = "vehicle"') Continue


</template>
