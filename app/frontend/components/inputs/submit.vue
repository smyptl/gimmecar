<script>
  export default {
    name: 'Submit',
    props: {
      loading: {
        type: Boolean,
        required: true,
        default: false,
      }
    },
  };
</script>

<template lang='pug'>
  button(type='submit' :disabled='loading')
    svg(v-if='loading' xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32' width='32' height='32' fill='white')
      path(opacity='0.25' d='M16 0 A16 16 0 0 0 16 32 A16 16 0 0 0 16 0 M16 4 A12 12 0 0 1 16 28 A12 12 0 0 1 16 4')
      path(d='M16 0 A16 16 0 0 1 32 16 L28 16 A12 12 0 0 0 16 4z')
        animateTransform(attributeName='transform' type='rotate' from='0 16 16' to='360 16 16' dur='0.8s' repeatCount='indefinite')
    slot
</template>

<style lang='stylus' scoped>
  @import '~Styles/global/layout'

  svg
    float: left
    margin-right: $padding-sm
    height: 1.25rem
    width: 1.25rem
</style>
