<script>
  import Capitalize from 'lodash/capitalize'
  import VehicleStatusIcons from 'Components/vehicle/status'

  import Shake from 'Utils/transitions/shake'
  import InputSubmit from 'Mixins/input_submit'
  import Popup from 'Components/popup'

  export default {
    name: 'VehicleStatus',
    data() {
      return {
        open: false,
        statuses: [
          'clean',
          'dirty',
          'service',
        ],
        form: new this.$form({
          status: '',
        })
      }
    },
    mixins: [
      InputSubmit,
    ],
    filters: {
      Capitalize
    },
    components: {
      Popup,
      VehicleStatusIcons,
    },
    mounted() {
      this.$http.get(this.$route.path + '/status')
        .then(response => {
          this.form.status = response.data.status
          this.open = true
        })
    },
    methods: {
      close() {
        this.$emit('close')
      },
      selectStatus(status) {
        this.form.status = status
        this.form.errors.clear('status')
        return null
      },
      changeVehicleStatus() {
        this.inputSubmitStart()

        this.$http.post(this.$route.path + '/status', this.form.data())
          .then(response => {
            this.form.errors.clear
            this.inputSubmitFinish()
            this.close()
          })
          .catch(error => {
            this.form.errors.record(error.response.data.errors)
            this.inputSubmitFinish()
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
          label.input-label Status
          .input-block.whole
            .panel.panel-input(v-error='form.errors.has("status")')
              table.input-table
                tbody
                  tr(
                    v-for='status in statuses'
                    :key='status'
                    @click.prevent='selectStatus(status)'
                    :class='{ selected: form.status == status }'
                  )

                    td.checkbox
                      input.input-field(type='radio'
                                        v-error='form.errors.has("status")'
                                        :checked='form.status == status')

                    td.checkbox
                      vehicle-status-icons(:status='status')
                    td {{ status | capitalize }}

          input-error-message(:errors='form.errors.get("status")')

      .panel-form.panel-form-padding.panel-popup-form-footer
        .input-submit.input-block
          input-submit.btn.btn-primary.right(@click.native.prevent='changeVehicleStatus()' :loading='input_submit_loading') Change
</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/form'
  @import '~Styles/components/inputs/table'
</style>
