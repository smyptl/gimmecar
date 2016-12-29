<script>
  import { compact } from 'lodash'

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
        return this.errors && this.errors[this.value] && compact(this.errors[this.value]).length
      },
    },
  }
</script>

<template lang='pug'>
  p.input-error-message(v-if='hasError')
    template(v-for='error in errors[value]')
      | {{ error }}
</template>
