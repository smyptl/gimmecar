<script>
  import Popup from 'Components/popup'

  export default {
    data () {
      return {
        open: false,
      }
    },
    mounted () {
      this.open = true
    },
    components: {
      Popup
    },
    methods: {
      close () {
        this.open = false
      }
    },
  }
</script>

<template lang='pug'>
  popup(v-if='open')
    .panel-popup-form
      .panel-base-header
        h2 Close - #12312313

      .form-container
        label.input-label(for='drop_off_date') Drop Off
        .input-block.whole
          input.input-field.input-contrast#drop_off_date(type='text')

</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/form'
</style>
