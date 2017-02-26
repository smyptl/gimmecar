<script>
  import Compact from 'lodash/compact'

  export default {
    props: {
      errors: {
        required: true,
      },
    },
    computed: {
      hasError() {
        if (this.errors) {
          return this.errors.length > 0
        }

        return false
      },
    },
  }
</script>

<template lang='pug'>
  p.input-error-message
    template(v-for='(error, index) in errors')
      | {{ error }}
      template(v-if='errors.length > 1 && (index + 1) != errors.length')
        | ,&nbsp;
</template>
