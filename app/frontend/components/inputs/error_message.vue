<script>
  import Compact from 'lodash/compact'

  export default {
    props: {
      value: {
        type: String,
        required: true
      },
      errors: {
        type: Object,
        default() {
          return {}
        },
      },
    },
    computed: {
      hasError() {
        return this.errors && this.errors[this.value] && Compact(this.errors[this.value]).length
      },
    },
  }
</script>

<template lang='pug'>
  p.input-error-message(v-if='hasError')
    template(v-for='(error, index) in errors[value]')
      | {{ error }}
      template(v-if='errors[value].length > 1 && (index + 1) != errors[value].length')
        | ,&nbsp;
</template>
