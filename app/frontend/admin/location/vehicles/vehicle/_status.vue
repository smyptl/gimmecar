<script>
  import Shake from 'Utils/transitions/shake'

  import Popup from 'Components/popup'

  export default {
    data () {
      return {
        open: false,
        form: new this.$form({
          status: '',
        })
      }
    },
    mounted () {
      this.open = true
    },
    components: {
      Popup,
    },
    methods: {
      close () {
        this.$emit('close')
      },
      changeVehicleStatus () {
        this.$http.post(this.$route.path + '/status', {
          status: this.form.data(),
        })
        .then(response => {
          this.form.errors.clear
          this.close()
        })
        .catch(error => {
          this.form.errors.record(error.response.data.errors)
        })
      },
    },
  }
</script>

<template lang='pug'>
  popup(v-if='open' @closed='close')
    .panel-form-popup
      .panel-form.panel-form-padding
        h4.panel-form-popup-header Change Status

      .panel-form.panel-form-padding.panel-popup-form-content
        .input-row
          label.input-label(for='vehicle_status') Status
          .input-block.whole
            select.input-field#vehicle_status(
              v-model='form.status'
              v-error='form.errors.has("status")'
              @input='form.errors.clear("status")')

              option(value='' disabled) ----
              option(value='clean') Clean
              option(value='dirty') Dirty
              option(value='service') In Service
          input-error-message(v-bind:errors='form.errors.get("status")')

      .panel-form.panel-form-padding.panel-popup-form-footer
        .input-submit.input-block
          button.btn.btn-primary.right(@click.prevent='changeVehicleStatus()') Update
</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/form'
</style>
