<script>
  import RentalInvoice from 'Admin/location/components/rental_invoice'
  import FinancialResponsibility from 'Components/financial_responsibility'
  import TermsAndConditions from 'Components/terms_and_conditions'

  export default {
    name: 'print',
    data () {
      return {
        summary: {}
      }
    },
    mounted () {
      this.$http.get(window.location.pathname)
        .then(response => {
          this.summary = response.data
        })
    },
    components: {
      RentalInvoice,
      FinancialResponsibility,
      TermsAndConditions,
    },
  }
</script>

<template lang='pug'>
  div
    .whole
      h1.logo.left GimmeCar
      h4.right.text-light Invoice

    .whole.margin-top-default
      b.text-light Prepared For:
      h4 {{ summary.driver_name }}

    .whole.margin-top-default.rental-invoice-summary
      h4.invoice-one-line We appreicate your business!
      p Thanks for being a customer. A detailed summary of your invoice is below. If you have any questions, we are happy to help. Email support@gimmecar.com or call 909.318.0450.
      h4.invoice-one-line.margin-bottom-default

    rental-invoice.page-break(v-bind:summary='summary')

    .page-break
      financial-responsibility.whole.left

      .one-half.left
        img(:src='this.summary.driver_financial_responsibility_signature')
        h5 {{ this.summary.driver_name }}
      .one-half.left(v-if='this.summary.additional_driver_name')
        img(:src='this.summary.additional_driver_financial_responsibility_signature')
        h5 {{ this.summary.additional_driver_name }}


    .page-break
      terms-and-conditions.whole.left
      .one-half.left
        img(:src='this.summary.driver_signature')
        h5 {{ this.summary.driver_name }}
      .one-half.left(v-if='this.summary.additional_driver_name')
        img(:src='this.summary.additional_driver_signature')
        h5 {{ this.summary.additional_driver_name }}


</template>

<style lang='stylus' scoped>
  .page-break
    page-break-after: always

  img
    max-height: 12rem
    max-width: 100%

</style>
