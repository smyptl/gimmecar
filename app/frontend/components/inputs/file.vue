<script>
  import Moment from 'moment'

  export default {
    name: 'InputFile',
    props: {
      value: {
        required: true,
      },
    },
    methods: {
      process(event) {
        this.emitInput(event.target.files[0])
      },
      emitInput(value) {
        this.$emit('input', value)
      }
    },
  }
</script>

<template lang='pug'>
  input.input-field(
    type='file'
    @change='process($event)')
</template>
