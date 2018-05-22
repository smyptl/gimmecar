<script>
  import Shake from 'Utils/transitions/shake'

  import InputSubmit from 'Mixins/input_submit'

  import Popup from 'Components/popup'

  export default {
    name: 'AddContactInfo',
    props: {
      url: {
        required: true,
        type: String,
      },
    },
    data() {
      return {
        open: false,
        form: new this.$form({
          add_email: false,
          email: {
            email_type: '',
            email: '',
            notes: '',
          },
          add_address: false,
          address: {
            address_type: '',
            street1: '',
            street2: '',
            city: '',
            state: '',
            zip_code: '',
            notes: '',
          },
          add_phone_number: false,
          phone_number: {
            phone_type: '',
            number: '',
            extension: '',
            notes: '',
          }
        }),
      }
    },
    mixins: [
      InputSubmit,
    ],
    components: {
      Popup,
    },
    mounted() {
      this.open = true
    },
    methods: {
      close() {
        this.$emit('close')
      },
      addContactInfo() {
        this.inputSubmitStart()

        this.$http.post(this.url, this.form.data())
          .then(response => {
            this.form.errors.clear
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
        h4.panel-form-popup-header Add Contact Info

      form(@submit.prevent='addContactInfo()')
        .panel-form.panel-form-padding.panel-popup-form-content
          .input-block.whole.mt-default.mb-sm(v-if='form.errors.has("base")')
            input-error-message(:base='true' :errors='form.errors.get("base")')

          .input-row
            label.input-label(for='add_email') Email
            .input-flex-container.whole
              .input-block.input-element-fixed
                input.input-field#add_email(type='checkbox' v-model='form.add_email' @input='form.errors.clear("base")')

              .input-element-flex(v-if='form.add_email')
                .input-row
                  .input-block.whole
                    select.input-field#email_email_type(
                      v-model='form.email.email_type'
                      v-error='form.errors.has("email_email_type")'
                      @input='form.errors.clear("email_email_type")')

                      option(value='') -- Type --
                      option(value='personal') Personal
                      option(value='work') Work
                  input-error-message(:errors='form.errors.get("email_email_type")')

                .input-row
                  .input-block.whole
                    input.input-field#email_email(
                      type='text'
                      placeholder='Email'
                      v-model='form.email.email'
                      v-error='form.errors.has("email_email")'
                      @input='form.errors.clear("email_email")')
                  input-error-message(:errors='form.errors.get("email_email")')

          .input-row
            label.input-label(for='add_address') Address
            .input-flex-container.whole
              .input-block.input-element-fixed
                input.input-field#add_address(type='checkbox' v-model='form.add_address' @input='form.errors.clear("base")')

              .input-element-flex(v-if='form.add_address')
                .input-row
                  .input-block.whole
                    select.input-field#address_address_type(
                      v-model='form.address.address_type'
                      v-error='form.errors.has("address_address_type")'
                      @input='form.errors.clear("address_address_type")')

                      option(value='') -- Type --
                      option(value='home') Home
                      option(value='work') Work
                  input-error-message(:errors='form.errors.get("address_address_type")')

                .input-row
                  .input-block.whole
                    input.input-field#address_street1(
                      type='text'
                      placeholder='Address 1'
                      v-model='form.address.street1'
                      v-error='form.errors.has("address_street1")'
                      @input='form.errors.clear("address_street1")')
                  input-error-message(:errors='form.errors.get("address_street1")')

                .input-row
                  .input-block.whole
                    input.input-field#address_street2(
                      type='text'
                      placeholder='Address 2'
                      v-model='form.address.street2'
                      v-error='form.errors.has("address_street2")'
                      @input='form.errors.clear("address_street2")')
                  input-error-message(:errors='form.errors.get("address_street2")')

                .input-row
                  .input-container.two-fifths
                    .input-block.whole
                      input.input-field#address_city(
                        type='text'
                        placeholder='City'
                        v-model='form.address.city'
                        v-error='form.errors.has("address_city")'
                        @input='form.errors.clear("address_city")')
                    input-error-message(:errors='form.errors.get("address_city")')

                  .input-container.three-fifths
                    .input-container.two-thirds.fixed
                      .input-block.whole
                        input.input-field#address_state(
                          type='text'
                          placeholder='State'
                          v-model='form.address.state'
                          v-error='form.errors.has("address_state")'
                          @input='form.errors.clear("address_state")')
                      input-error-message(:errors='form.errors.get("address_state")')

                    .input-container.one-third.fixed
                      .input-block.whole
                        input.input-field#address_zip_code(
                          type='text'
                          placeholder='Zip Code'
                          v-model='form.address.zip_code'
                          v-error='form.errors.has("address_zip_code")'
                          @input='form.errors.clear("address_zip_code")')
                      input-error-message(:errors='form.errors.get("address_zip_code")')

          .input-row
            label.input-label(for='add_phone_number') Phone Number
            .input-flex-container.whole
              .input-block.input-element-fixed
                input.input-field#add_phone_number(type='checkbox' v-model='form.add_phone_number' @input='form.errors.clear("base")')

              .input-element-flex(v-if='form.add_phone_number')
                .input-row
                  .input-block.whole
                    select.input-field#phone_number_phone_type(
                      v-model='form.phone_number.phone_type'
                      v-error='form.errors.has("phone_number_phone_type")'
                      @input='form.errors.clear("phone_number_phone_type")')

                      option(value='') -- Type --
                      option(value='cell') Cell
                      option(value='home') Home
                      option(value='work') Work

                  input-error-message(:errors='form.errors.get("phone_number_phone_type")')

                .input-row
                  .input-container.three-fourths.fixed
                    .input-block.whole
                      input.input-field#phone_number_number(
                        type='text'
                        placeholder='Number'
                        v-model='form.phone_number.number'
                        v-error='form.errors.has("phone_number_number")'
                        @input='form.errors.clear("phone_number_number")')
                    input-error-message(:errors='form.errors.get("phone_number_number")')

                  .input-container.one-fourth.fixed
                    .input-block.whole
                      input.input-field#phone_number_extension(
                        type='text'
                        placeholder='Ext.'
                        v-model='form.phone_number.extension'
                        v-error='form.errors.has("phone_number_extension")'
                        @input='form.errors.clear("phone_number_extension")')
                    input-error-message(:errors='form.errors.get("phone_number_extension")')


        .panel-form.panel-form-padding.panel-popup-form-footer
          .input-submit.input-block
            input-submit.btn.btn-primary.right(:loading='input_submit_loading') Add
</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/form'
</style>
