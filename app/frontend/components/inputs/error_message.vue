<script>
  import Compact from 'lodash/compact'

  export default {
    props: {
      errors: {
        required: true,
      },
      base: {
        type: Boolean,
        default: false,
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
  p.input-error-message(:class=" { 'error-message-base': base }")
    template(v-for='(error, index) in errors')
      | {{ error }}
      template(v-if='errors.length > 1 && (index + 1) != errors.length')
        | ,&nbsp;
</template>

<style lang='stylus' scoped>
  @import '~Styles/global/colors'
  @import '~Styles/global/type'
  @import '~Styles/global/layout'

  .input-error-message
    float: left
    margin: -($input-margin-x) $input-padding-y $input-margin-x
    padding: $input-margin-x $padding-ex-sm

    border: 1px solid $border-color-yellow
    border-top: 0
    border-bottom-left-radius: $input-border-radius
    border-bottom-right-radius: $input-border-radius
    background-color: $background-color-yellow

    text-align: left
    font-size: $input-font-size
    font-weight: 600
    color: #444444

  .input-error-message:empty
    display: none

  .input-error-message.input-lg
    font-size: $font-size-default
    padding: $padding-ex-sm

  .input-error-message.error-message-base
    float: left
    width: 100%
    margin: 0
    padding: $padding-ex-sm

    border: 0
    border-radius: $input-border-radius
    background-color: $red

    font-size: $font-size-default
    font-weight: 600
    color: #ffffff
</style>
