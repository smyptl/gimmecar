<script>
  import Shake from 'Utils/transitions/shake'

  import RentalInvoice from 'Components/quote'

  import InputSubmit from 'Mixins/input_submit'

  import Signature     from 'Components/inputs/signature'
  import Payment       from 'Components/inputs/payment'

  import FinancialResponsibilitySignatures from 'Admin/location/components/financial_responsibility_signatures'
  import TermsAndConditionsSignatures      from 'Admin/location/components/terms_and_conditions_signatures'

  import DetailsForm from './details'
  import DriversForm from './drivers'
  import VehicleForm from './vehicles'

  export default {
    name: 'Rental-New',
    data() {
      return {
        rental: new this.$form({
          drop_off: new Date().setDate(new Date().getDate() + 1),
          vehicle_type: '',
          driver_id: '',
          driver: {
            name_first: '',
            name_last: '',
            license_number: '',
            license_state: 'California',
            license_country: 'United States',
            license_expiration_date: '',
            gender: '',
            date_of_birth: '',
            email: '',
            address: {
              street1: '',
              street2: '',
              city: '',
              state: 'California',
              zip_code: ''
            },
            phone_numbers: {
              cell: '',
              home: '',
            },
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
          add_additional_driver: false,
          additional_driver_id: '',
          additional_driver: {
            name_first: '',
            name_middle: '',
            name_last: '',
            license_number: '',
            license_state: 'California',
            license_country: 'United States',
            license_expiration_date: '',
            gender: '',
            date_of_birth: '',
            email: '',
            address: {
              street1: '',
              street2: '',
              city: '',
              state: 'California',
              zip_code: ''
            },
            phone_numbers: {
              cell: '',
              home: '',
            },
          },
          vehicle_id: '',
          pickup_odometer: '',
          pickup_fuel: 10,
          driver_financial_responsibility_signature: '',
          additional_driver_financial_responsibility_signature: '',
          driver_signature: '',
          additional_driver_signature: '',
          paid_by: 'driver',
          stripe_token: '',
          stripe_customer_id: '',
        }),
        current_step: 'Details',
        vehicles: [],
        summary: {},
      }
    },
    mixins: [
      InputSubmit,
    ],
    components: {
      DetailsForm,
      DriversForm,
      FinancialResponsibilitySignatures,
      Payment,
      RentalInvoice,
      Signature,
      TermsAndConditionsSignatures,
      VehicleForm,
    },
    computed: {
      pickup() {
        return new Date()
      },
      steps() {
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
      number_of_steps() {
        return this.steps.length
      },
      current_step_number() {
        return this.steps.indexOf(this.current_step) + 1
      },
    },
    methods: {
      nextStep() {
        this.current_step = this.steps[this.steps.indexOf(this.current_step) + 1]
      },
      goBack() {
        this.current_step = this.steps[this.steps.indexOf(this.current_step) - 1]
      },
      successResponse() {
        this.rental.errors.clear
        this.inputSubmitFinish()
      },
      errorResponse(error) {
        Shake(this.$refs.form)
        this.inputSubmitFinish()
        this.rental.errors.record(error.response.data.errors)
      },
      getRates() {
        this.inputSubmitStart()

        this.$http.post(this.$route.path + '/rates', this.rental.data())
          .then(response => {
            this.successResponse()
            this.summary = response.data
            this.nextStep()
          })
          .catch(error => {
            this.errorResponse(error)
          })
      },
      validateDrivers() {
        this.inputSubmitStart()

        this.$http.post(this.$route.path + '/validate-drivers', this.rental.data())
          .then(response => {
            this.rental.errors.clear
            this.getVehicles()
          })
          .catch(error => {
            this.errorResponse(error)
          })
      },
      getVehicles() {
        this.$http.post(this.$route.path + '/vehicles', this.rental.data())
          .then(response => {
            this.successResponse()
            this.vehicles = response.data
            this.nextStep()
          })
          .catch(error => {
            this.errorResponse(error)
          })
      },
      validateVehicle() {
        this.inputSubmitStart()

        this.$http.post(this.$route.path + '/validate-vehicle', this.rental.data())
          .then(response => {
            this.successResponse()
            this.nextStep()
          })
          .catch(error => {
            this.errorResponse(error)
          })
      },
      validateFinancialResponsibility() {
        this.inputSubmitStart()

        this.$http.post(this.$route.path + '/validate-financial-responsibility', this.rental.data())
          .then(response => {
            this.successResponse()
            this.nextStep()
          })
          .catch(error => {
            this.errorResponse(error)
          })
      },
      validateTermsAndConditions() {
        this.inputSubmitStart()

        this.$http.post(this.$route.path + '/validate-terms-and-conditions', this.rental.data())
          .then(response => {
            this.successResponse()
            this.nextStep()
          })
          .catch(error => {
            this.errorResponse(error)
          })
      },
      validatePayment() {
        this.inputSubmitStart()

        stripe.createToken(window.card).then(result => {
          if (result.error) {
            Shake(this.$refs.form)
            this.rental.errors.record({ card: [result.error.message] })
            this.inputSubmitFinish()
          } else {
            this.rental.errors.clear
            // Send the token to your server
            this.rental.stripe_token = result.token.id
            this.createRental()
          }
        });
      },
      createRental() {
        this.inputSubmitStart()

        this.$http.post(this.$route.path, this.rental.data())
          .then(response => {
            this.$router.push({ name: 'rental', params: { number: response.data.number }})
          })
          .catch(error => {
            this.errorResponse(error)
            this.rental.stripe_customer_id = error.response.data.stripe_customer_id
          })
      },
    },
  }

</script>

<template lang='pug'>
  .panel-form(ref='form')
    h3.panel-form-header
      | Rental: {{ current_step }}
      small.right {{ current_step_number }} of {{ number_of_steps }}

    template(v-if='current_step == "Details"')
      details-form(:form='rental')

      .input-submit.input-block
        input-submit.btn.btn-primary.right(@click.native.prevent='getRates()' :loading='input_submit_loading') Continue

    template(v-if='current_step == "Rates"')
      rental-invoice.input-block.mt-sm(:summary='summary' :estimated='true')

      .input-submit.input-block
        button.btn.left(@click.prevent='goBack()') Go Back
        button.btn.btn-primary.right(@click.prevent='nextStep()') Continue

    template(v-if='current_step == "Drivers"')
      drivers-form(:form='rental')

      .input-submit.input-block
        button.btn.left(@click.prevent='goBack()') Go Back
        input-submit.btn.btn-primary.right(@click.native.prevent='validateDrivers()' :loading='input_submit_loading') Continue

    template(v-if='current_step == "Vehicle"')
      vehicle-form(:form='rental' :vehicles='vehicles')

      .input-submit.input-block
        button.btn.left(@click.prevent='goBack()') Go Back
        input-submit.btn.btn-primary.right(@click.native.prevent='validateVehicle()' :loading='input_submit_loading') Continue

    template(v-if='current_step == "Financial Responsibility"')
      financial-responsibility-signatures(:form='rental')

      .input-block.input-submit
        button.btn.left(@click.prevent='goBack()') Go Back
        input-submit.btn.btn-primary.right(@click.native.prevent='validateFinancialResponsibility()' :loading='input_submit_loading') Continue

    template(v-if='current_step == "Terms & Conditions"')
      rental-invoice.input-block.mt-sm(:summary='summary')
      terms-and-conditions-signatures.mt-sm(:form='rental')

      .input-block.input-submit
        button.btn.left(@click.prevent='goBack()') Go Back
        input-submit.btn.btn-primary.right(@click.native.prevent='validateTermsAndConditions()' :loading='input_submit_loading')  Continue

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
        input-error-message(:errors='rental.errors.get("paid_by")')

      .input-row
        label.input-label
          | Card Number
          .input-label-note.right DO NOT accept prepaid cards.
        .input-block.whole
          payment(
            @add-error='rental.errors.record({ card: [$event] })'
            @clear-error="rental.errors.clear()"
            v-error='rental.errors.has("card")')
        input-error-message(:errors='rental.errors.get("card")')

      .input-block.input-submit
        button.btn.left(@click.prevent='goBack()') Go Back
        input-submit.btn.btn-primary.right(@click.native.prevent='validatePayment()' :loading='input_submit_loading') Continue
</template>

<style lang='stylus'>
  @import '~Styles/components/panels/form'
  @import '~Styles/components/panels/table'
</style>
