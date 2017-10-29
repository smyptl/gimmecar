<script>
  import FinancialResponsibility from 'Components/financial_responsibility'
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
      financial-responsibility

    h6.input-label {{ form.driver.name_first }} {{ form.driver.name_last }}
    .input-block.whole
      signature(
        v-model='form.driver_financial_responsibility_signature'
        v-error='form.errors.has("driver_financial_responsibility_signature")'
        @input='form.errors.clear("driver_financial_responsibility_signature")')
    input-error-message(v-bind:errors='form.errors.get("driver_financial_responsibility_signature")')

    template(v-if='form.add_additional_driver')
      h6.input-label.margin-top-default {{ form.additional_driver.name_first }} {{ form.additional_driver.name_last }}
      .input-block.whole
        signature(
          v-model='form.additional_driver_financial_responsibility_signature'
          v-error='form.errors.has("additional_driver_financial_responsibility_signature")'
          @input='form.errors.clear("additional_driver_financial_responsibility_signature")')
      input-error-message(v-bind:errors='form.errors.get("additional_driver_financial_responsibility_signature")')
</template>
