<script>
  import TermsAndConditions from 'Components/terms_and_conditions'
  import Signature from 'Components/inputs/signature'

  export default {
    props: {
      form: {
        type: Object,
        required: true,
      },
    },
    components: {
      TermsAndConditions,
      Signature,
    },
  }
</script>

<template lang='pug'>
  div
    .input-block.mt-sm
      terms-and-conditions

    .input-block
      h6.input-label {{ form.driver.name_first }} {{ form.driver.name_last }}
      signature(
        v-model='form.driver_signature'
        v-error='form.errors.has("driver_signature")'
        @input='form.errors.clear("driver_signature")')
      input-error-message(:errors='form.errors.get("driver_signature")')

    template(v-if='form.add_additional_driver')
      .input-block
        h6.input-label.mt-default {{ form.additional_driver.name_first }} {{ form.additional_driver.name_last }}
        signature(
          v-model='form.additional_driver_signature'
          v-error='form.errors.has("additional_driver_signature")'
          @input='form.errors.clear("additional_driver_signature")')
        input-error-message(:errors='form.errors.get("additional_driver_signature")')
</template>
