<script>
  import TermsAndConditions from 'Components/term_and_conditions'
  import Signature from 'Components/inputs/signature'

  export default {
    props: {
      form: {
        type: Object,
        required: true,
      },
    },
    components: {
      FinancialResponsibility,
      Signature,
    },
  }
</script>

<template lang='pug'>
  div
    .input-block.margin-top-sm
      terms-and-conditions

    h6.input-label {{ rental.driver.name_first }} {{ rental.driver.name_last }}
    .input-block.whole
      signature(
        v-model='rental.driver_signature'
        v-error='rental.errors.has("driver_signature")'
        @input='rental.errors.clear("driver_signature")')
    input-error-message(v-bind:errors='rental.errors.get("driver_signature")')

    template(v-if='rental.add_additional_driver')
      h6.input-label.margin-top-default {{ rental.additional_driver.name_first }} {{ rental.additional_driver.name_last }}
      .input-block.whole
        signature(
          v-model='rental.additional_driver_signature'
          v-error='rental.errors.has("additional_driver_signature")'
          @input='rental.errors.clear("additional_driver_signature")')
      input-error-message(v-bind:errors='rental.errors.get("additional_driver_signature")')
</template>
