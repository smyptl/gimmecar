<script>
  import Capitalize from 'lodash/capitalize'

  import Form from 'Utils/form'
  import Shake from 'Utils/transitions/shake'

  import RentalInvoice from 'Admin/location/components/rental_invoice'
  import Driver from 'Admin/location/components/driver'

  import InputDateTime from 'Components/inputs/date_time'
  import Signature from 'Components/inputs/signature'
  import Payment from 'Components/inputs/payment'

  export default {
    name: 'new',
    data () {
      return {
        rental: new Form({
          pickup: new Date(),
          drop_off: new Date().setDate(new Date().getDate() + 1),
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
          financial_responsibility_signature: '',
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
          },
          additional_driver_signature: '',
          vehicle_id: null,
          pickup_odometer: '',
          pickup_fuel: 10,
          promo_code: '',
          card_selected: '',
          stripe_token: '',
          stripe_customer_id: '',
        }),
        card_error_message: '',
        current_step: 'Details',
        vehicles: [],
        summary: {},
      }
    },
    components: {
      Driver,
      InputDateTime,
      Payment,
      RentalInvoice,
      Signature,
    },
    filters: {
      Capitalize,
    },
    computed: {
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
        this.$http.post(this.$route.path + '/', {
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
      validatePayment () {
        stripe.createToken(window.card).then(result => {
          if (result.error) {
            this.card_error_message = result.error.message
          } else {
            // Send the token to your server
            this.stripe_token = result.token
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
          console.log('created')
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
  .form-container(ref='form')
    h4.form-header.form-header-first
      | Rental: {{ current_step }}
      small.right {{ current_step_number }} of {{ number_of_steps }}

    template(v-if='current_step == "Details"')
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

    template(v-if='current_step == "Rates"')
      rental-invoice.margin-top-sm(v-bind:summary='summary' v-bind:estimated='true')

      .input-submit.input-block
        button.btn.left(@click.prevent='goBack()') Go Back
        button.btn.btn-primary.right(@click.prevent='nextStep()') Continue

    template(v-if='current_step == "Drivers"')
      driver(v-bind:form='rental')

      .input-submit.input-block
        button.btn.left(@click.prevent='goBack()') Go Back
        button.btn.btn-primary.right(@click.prevent='getVehicles()') Continue

    template(v-if='current_step == "Vehicle"')
      .input-block.whole
        table.panel-table#vehicle-table
          thead
            tr
              th
              th Make - Model
              th Color
              th License #
          tbody
            tr(v-for='vehicle in vehicles' @click.prevent='rental.vehicle_id = vehicle.id' v-bind:class='{ selected: rental.vehicle_id == vehicle.id }')
              td
                button.button-vehicle-id
              td {{ vehicle.make }} {{ vehicle.model }}
              td {{ vehicle.color | capitalize }}
              td {{ vehicle.license_number }}

      .input-row.margin-top-default
        .input-container.two-fifths
          label.input-label(for='pickup_odometer') Vehicle Odometer
          .input-block.whole
            input.input-field#pickup_odometer(type='text' v-model='rental.pickup_odometer')
        .input-container.three-fifths
          label.input-label(for='pickup_fuel')
            | Fuel Level
            .input-label-note.right {{ rental.pickup_fuel * 10 }}%
          .input-block.whole
            input.input-range#pickup_fuel(type='range' v-model.number='rental.pickup_fuel' min='0' max='10')

      .input-submit.input-block
        button.btn.left(@click.prevent='goBack()') Go Back
        button.btn.btn-primary.right(@click.prevent='nextStep()') Continue

    template(v-if='current_step == "Add-Ons"')
      .input-row
        .input-container.one-third
          label.input-label Promo Code:
          .input-block.whole
            input.input-field#promo_code(type='text' placeholder='A912RED1' v-model='rental.promo_code')
          input-error-message(field='drop_off' v-bind:errors='rental.errors.get("drop_off")')

      .input-submit.input-block
        button.btn.left(@click.prevent='goBack()') Go Back
        button.btn.btn-primary.right(@click.prevent='nextStep()') Continue

    template(v-if='current_step == "Financial Responsibility"')
      .input-block
        h5.margin-top-sm Notice About Your Financial Responibility
        p You are responsible for all collision damage to the vehicle, even if someone else caused it or the cause is unknown. You are responsible for the cost or repair up to the value of the vehicle, towing, storage and impound fees. Your own insurance, or the issuer of the credit card you use to pay for the rental, may cover all or porat of your financial responibility for damage to, or losee of the rented vehicle. You should check with your insurance company or credit card issuer, to find out about your coverage and the amount of deductible, if any, for which you may by liable. If you use a credit card that provides coverage for your responsibility for damage to, or loss of, the vehicle, you should check with the issuer to determine whether or not you must first exhaust the coverage limits of your own insurance before the credit card coverage applies.

        p By initialing below, you agree to be responsible for all damage to, or loss of, the Vehicle.
      h6.input-label {{ rental.driver.first_name }} {{ rental.driver.last_name }}
      .input-block.whole
        signature(v-model='rental.financial_responsibility_signature')

      .input-block.input-submit
        button.btn.left(@click.prevent='goBack()') Go Back
        button.btn.btn-primary.right(@click.prevent='nextStep()') Continue

    template(v-if='current_step == "Terms & Conditions"')
      rental-invoice.margin-top-sm(v-bind:summary='summary')
      .input-block
        h5.margin-top-sm Rental Agreement Terms and Conditions
        p
          | 1.&nbsp;
          u Definitions.
          | &nbsp;"Agreement" means all terms and conditions found, any addenda and additional materials we provide at the time of rental. "You" or "your" means the person identified as the renters / drivers, and person signing this Agreement, and Authorized Driver and any person or organization to whom charges are billed by us at its or your direction. All persons referred to as "you" or "your" are jointly and severally bound by this agreement. "We", "our" or "us" means Auto Guru Rental System, Inc. DBA GimmeCar. "Authorized Driver" means the renter, the renter's spource, the renter's employer and co-worker if engaged in business activity with the renter while using the Vehicle and is at least age 21, and any additional driver listed by us on this Agreement, provided that each such person has a valid driver's license. "Vehicle" means the motor vehicle identified in this Agreement and vehicle we substitute for it, all its tires, tools, accessories, equipment, keys and Vehicle documents.

        p By signing below, you agree to all of the terms and conditions of this rental agreement. You acknowledge the Vehicle has no damage. Your signature below authorizes us to process a credit card voucher in your name for all rental charges due.

      h6.input-label {{ rental.driver.first_name }} {{ rental.driver.last_name }}
      .input-block.whole
        signature(v-model='rental.driver_signature')

      template(v-if='rental.add_additional_driver')
        h6.input-label.margin-top-default {{ rental.additional_driver.first_name }} {{ rental.additional_driver.last_name }}
        .input-block.whole
          signature(v-model='rental.additional_driver_signature')

      .input-block.input-submit
        button.btn.left(@click.prevent='goBack()') Go Back
        button.btn.btn-primary.right(@click.prevent='nextStep()') Continue


    template(v-if='current_step == "Payment"')
      .input-row
        label.input-label
          | Card Number
          .input-label-note.right DO NOT accept prepaid or debit cards. Only credit cards accepted.
        .input-block.whole
          payment
        p.input-error-message#stripe-card-errors

      .input-block.input-submit
        button.btn.left(@click.prevent='goBack()') Go Back
        button.btn.btn-primary.right(@click.prevent='validatePayment') Continue

</template>

<style lang='stylus' scoped>
  @import '~Styles/global/colors'
  @import '~Styles/global/layout'

  #vehicle-table
    font-size: 0.875rem
    text-align: left
    font-weight: 400
    vertical-align: middle

    td,
    th
      margin: 0
      padding: $padding-sm

    thead
      color: #888888

    tbody
      td:first-of-type
        border-top-left-radius: 0.125rem
        border-bottom-left-radius: 0.125rem
        padding-right: 0
        width: 1rem + $padding-sm

      td:last-of-type
        border-top-right-radius: 0.125rem
        border-bottom-right-radius: 0.125rem

      td
        background: $background-color-panel

      tr
        border-bottom: 1px solid $border-color-light
        cursor: pointer

      tr:last-of-type
        border-bottom: 0

      tr.selected
        font-weight: 600

        .button-vehicle-id
          border: 0.25rem solid $border-color-blue
          background: $blue

    .button-vehicle-id
      width: 1rem
      height: @width
      padding: 0
      margin: 0
      float: left

      background: #ffffff
      border: 0.125rem solid $border-color-input
      border-radius: 50%

</style>
