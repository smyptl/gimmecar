<script>
  import RentalInvoice           from 'Components/quote'
  import FinancialResponsibility from 'Components/financial_responsibility'
  import TermsAndConditions      from 'Components/terms_and_conditions'
  import AddressD                from 'Components/address'

  export default {
    name: 'Invoice',
    data() {
      return {
        summary: {}
      }
    },
    components: {
      AddressD,
      RentalInvoice,
      FinancialResponsibility,
      TermsAndConditions,
    },
    mounted() {
      this.$http.get(window.location.pathname)
        .then(response => {
          this.summary = response.data
        })
    },
    methods: {
      goBack() {
        this.$router.push({ name: 'rental', params: { number: this.$route.params.number }})
      },
      print() {
        window.print()
      },
    },
  }
</script>

<template lang='pug'>
  .left
    .whole
      button.left.btn(@click='goBack()') Go Back
      button.right.btn.btn-primary(@click='print()') Print

    .whole
      h1.logo.left GimmeCar

    .whole
      h4 {{ summary.driver.name }}
      p
        span.block License #:&nbsp;
        b.block {{ summary.driver.license_number }}
      p
        span.block Address:&nbsp;
        b
          address-d(:address='summary.driver.address_primary')

    .whole.mt-default(v-if='this.summary.additional_driver')
      h4 {{ summary.additional_driver.name }}
      p
        span.block License #:&nbsp;
        b.block {{ summary.additional_driver.license_number }}
      p
        span.block Address:&nbsp;
        b
          address-d(:address='summary.additional_driver.address_primary')


    .whole.mt-default.rental-invoice-summary
      h4.invoice-one-line We appreicate your business!
      p Thanks for being a customer. A detailed summary of your invoice is below. If you have any questions, we are happy to help. Email support@gimmecar.com or call 909.318.0450.
      h4.invoice-one-line.mb-default

    rental-invoice.page-break(:summary='summary')

    .page-break
      financial-responsibility.whole.left

      .one-half.left
        img.signature(:src='this.summary.driver_financial_responsibility_signature')
        h5 {{ this.summary.driver.name }}
      .one-half.left(v-if='this.summary.additional_driver')
        img.signature(:src='this.summary.additional_driver_financial_responsibility_signature')
        h5 {{ this.summary.additional_driver.name }}


    .page-break
      terms-and-conditions.whole.left
      .one-half.left
        img.signature(:src='this.summary.driver_signature')
        h5 {{ this.summary.driver.name }}
      .one-half.left(v-if='this.summary.additional_driver')
        img.signature(:src='this.summary.additional_driver_signature')
        h5 {{ this.summary.additional_driver.name }}


</template>

<style lang='stylus'>
  @media print
    header
      display: none !important

    button
      display: none !important

    html
      font-size: 90% !important

    .page-break
      page-break-after: always

  img.signature
    max-height: 12rem
    max-width: 100%

</style>
