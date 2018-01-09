<script>
  import Form from 'Utils/form'
  import Shake from 'Utils/transitions/shake'

  import RentalInvoice from 'Admin/location/components/rental_invoice'
  import Driver from 'Admin/location/components/driver'

  import InputDateTime from 'Components/inputs/date_time'
  import Signature from 'Components/inputs/signature'
  import Payment from 'Components/inputs/payment'
  import FinancialResponsibilitySignatures from 'Admin/location/components/financial_responsibility_signatures'
  import TermsAndConditionsSignatures from 'Admin/location/components/terms_and_conditions_signatures'
  import VehicleForm from './vehicles.vue'

  export default {
    name: 'new',
    data () {
      return {
        rental: new Form({
          drop_off: new Date().setDate(new Date().getDate() + 1),
          vehicle_type: '',
          promo_code: null,
          driver_id: null,
          driver: {
            name_first: '',
            name_last: '',
            license_number: '',
            license_state: 'California',
            license_country: 'United States',
            license_expiration_date: '',
            address_1: '',
            address_2: '',
            city: '',
            state: 'California',
            zip_code: '',
            country: 'United States',
            gender: '',
            date_of_birth: '',
            cell_phone_number: '',
            home_phone_number: '',
            insurance: {
              company_name: '',
              policy_number: '',
              phone_number: '',
              effective_date: '',
              expiration_date: '',
              agent: '',
              verified: false,
              verify_date: new Date(),
              verify_agent: '',
              verify_call_center: '',
            },
          },
          driver_signature: '',
          driver_financial_responsibility_signature: '',
          additional_driver_financial_responsibility_signature: '',
          add_additional_driver: false,
          additional_driver_id: null,
          additional_driver: {
            name_first: '',
            name_middle: '',
            name_last: '',
            license_number: '',
            license_state: 'California',
            license_country: 'United States',
            license_expiration_date: '',
            address_1: '',
            address_2: '',
            city: '',
            state: 'California',
            zip_code: '',
            country: 'United States',
            gender: '',
            date_of_birth: '',
            cell_phone_number: '',
            home_phone_number: '',
          },
          additional_driver_signature: '',
          vehicle_id: null,
          pickup_odometer: '',
          pickup_fuel: 10,
          promo_code: '',
          paid_by: 'driver',
          stripe_token: '',
          stripe_customer_id: '',
        }),
        current_step: 'Details',
        vehicles: [],
        summary: {},
        disabled_button: false,
      }
    },
    components: {
      Driver,
      InputDateTime,
      FinancialResponsibilitySignatures,
      Payment,
      RentalInvoice,
      Signature,
      TermsAndConditionsSignatures,
      VehicleForm,
    },
    computed: {
      pickup () {
        return new Date()
      },
      steps () {
        return [
          'Details',
          'Rates',
          'Drivers',
          'Vehicle',
          'Financial Responsibility',
          'Terms & Conditions',
          'Payment',
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
      validateDrivers () {
        this.$http.post(this.$route.path + '/validate-drivers', {
          rental: this.rental.data(),
        })
        .then(response => {
          this.rental.errors.clear
          this.getVehicles()
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
      validateVehicle () {
        this.$http.post(this.$route.path + '/validate-vehicle', {
          rental: this.rental.data(),
        })
        .then(response => {
          this.rental.errors.clear
          this.nextStep()
        })
        .catch(error => {
          Shake(this.$refs.form)
          this.rental.errors.record(error.response.data.errors)
        })
      },
      validateFinancialResponsibility () {
        this.$http.post(this.$route.path + '/validate-financial-responsibility', {
          rental: this.rental.data(),
        })
        .then(response => {
          this.rental.errors.clear
          this.nextStep()
        })
        .catch(error => {
          Shake(this.$refs.form)
          this.rental.errors.record(error.response.data.errors)
        })
      },
      validateTermsAndConditions () {
        this.$http.post(this.$route.path + '/validate-terms-and-conditions', {
          rental: this.rental.data(),
        })
        .then(response => {
          this.rental.errors.clear
          this.nextStep()
        })
        .catch(error => {
          Shake(this.$refs.form)
          this.rental.errors.record(error.response.data.errors)
        })
      },
      validatePayment () {
        this.disabled_button = true

        stripe.createToken(window.card).then(result => {
          if (result.error) {
            Shake(this.$refs.form)
            this.rental.errors.record({ card: [result.error.message] })
            this.disabled_button = false
          } else {
            this.rental.errors.clear
            // Send the token to your server
            this.rental.stripe_token = result.token.id
            this.createRental()
          }
        });
      },
      createRental () {
        this.$http.post(this.$route.path, {
          rental: this.rental.data(),
        })
        .then(response => {
          this.rental.errors.clear
          this.$router.push({ name: 'rental', params: { number: response.data.rental_number }})
        })
        .catch(error => {
          Shake(this.$refs.form)
          this.rental.stripe_customer_id = error.response.data.stripe_customer_id
          this.rental.errors.record(error.response.data.errors)
          this.disabled_button = false
        })
      },
    },
  }

</script>

<template lang='pug'>
  .gimmecar-app-container
    .panel-form(ref='form')
      h3.panel-form-header
        | Rental: {{ current_step }}
        small.right {{ current_step_number }} of {{ number_of_steps }}

      template(v-if='current_step == "Details"')
        .input-row
          .input-container.one-half
            label.input-label Pickup *
            .input-block.whole
              input-date-time(v-model='pickup' disabled=true)

          .input-container.one-half
            label.input-label Drop-off *
            .input-block.whole
              input-date-time(
                v-model='rental.drop_off'
                v-error='rental.errors.has("drop_off")'
                @input='rental.errors.clear("drop_off")')
            input-error-message(v-bind:errors='rental.errors.get("drop_off")')

        .input-row
          .input-container.whole
            label.input-label(for='vehicle_type') Vehicle Type *
            .input-block.whole
              select.input-field#vehicle_type(
                v-model='rental.vehicle_type'
                v-error='rental.errors.has("vehicle_type")'
                @input='rental.errors.clear("vehicle_type")')

                option(value='' disabled) -- Select Vehicle Type --
                option(value='subcompact') Subcompact (Toyota Yaris iA)
                option(value='compact') Compact (Toyota Corolla)
                option(value='mid_size') Mid-Size (Toyota Camry)
            input-error-message(v-bind:errors='rental.errors.get("vehicle_type")')

        .input-submit.input-block
          button.btn.btn-primary.right(@click.prevent='getRates()') Continue

      template(v-if='current_step == "Rates"')
        rental-invoice.input-block.margin-top-sm(v-bind:summary='summary' v-bind:estimated='true')

        .input-submit.input-block
          button.btn.left(@click.prevent='goBack()') Go Back
          button.btn.btn-primary.right(@click.prevent='nextStep()') Continue

      template(v-if='current_step == "Drivers"')
        driver(v-bind:form='rental')

        .input-submit.input-block
          button.btn.left(@click.prevent='goBack()') Go Back
          button.btn.btn-primary.right(@click.prevent='validateDrivers()') Continue

      template(v-if='current_step == "Vehicle"')
        vehicle-form(v-bind:form='rental' v-bind:vehicles='vehicles')

        .input-submit.input-block
          button.btn.left(@click.prevent='goBack()') Go Back
          button.btn.btn-primary.right(@click.prevent='validateVehicle()') Continue

      template(v-if='current_step == "Financial Responsibility"')
        financial-responsibility-signatures(v-bind:form='rental')

        .input-block.input-submit
          button.btn.left(@click.prevent='goBack()') Go Back
          button.btn.btn-primary.right(@click.prevent='validateFinancialResponsibility()') Continue

      template(v-if='current_step == "Terms & Conditions"')
        rental-invoice.input-block.margin-top-sm(v-bind:summary='summary')
        terms-and-conditions-signatures.margin-top-sm(v-bind:form='rental')

        .input-block.input-submit
          button.btn.left(@click.prevent='goBack()') Go Back
          button.btn.btn-primary.right(@click.prevent='validateTermsAndConditions()') Continue

      template(v-if='current_step == "Payment"')
        .input-row
          label.input-label(for='paid_by')
            | Paid By
            .input-label-note.right Insure it matches name on card.
          .input-block.whole
            template(v-if='rental.add_additional_driver')
              select.input-field#paid_by(
                v-model='rental.paid_by'
                v-error='rental.errors.has("paid_by")'
                @input='rental.errors.clear("paid_by")')

                option(value='driver') {{ rental.driver.name_first }} {{ rental.driver.name_last }}
                option(value='additional_driver') {{ rental.additional_driver.name_first }} {{ rental.additional_driver.name_last }}
            template(v-else)
              select.input-field#paid_by(
                disabled
                v-model='rental.paid_by'
                v-error='rental.errors.has("paid_by")'
                @input='rental.errors.clear("paid_by")')

                option(value='driver') {{ rental.driver.name_first }} {{ rental.driver.name_last }}
          input-error-message(v-bind:errors='rental.errors.get("paid_by")')

        .input-row
          label.input-label
            | Card Number
            .input-label-note.right DO NOT accept prepaid cards.
          .input-block.whole
            payment(v-error='rental.errors.has("card")' @click='rental.errors.clear("card")')
          input-error-message(v-bind:errors='rental.errors.get("card")')

        .input-block.input-submit
          button.btn.left(@click.prevent='goBack()') Go Back
          button.btn.btn-primary.right(@click.prevent='validatePayment' v-bind:disabled='disabled_button') Continue

</template>

<style lang='stylus'>
  @import '~Styles/components/panels/form'

</style>
