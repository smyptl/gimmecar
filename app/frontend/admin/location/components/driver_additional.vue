<script>
  import InputDate from 'Components/inputs/date'

  export default {
    name: 'DriverAdditional',
    props: {
      form: {
        type: Object,
        required: true,
      },
    },
    components: {
      InputDate,
    },
  }

</script>

<template lang='pug'>
  div
    .input-container.whole
      .input-block
        label.input-label(for='additional_driver_name_first') Name
      .input-container.three-fifths
        .input-container.three-fifths.fixed
          .input-block
            input.input-field#additional_driver_name_first(
              type='text'
              placeholder='First'
              v-model='form.additional_driver.name_first'
              v-error='form.errors.has("additional_driver_name_first")'
              @input='form.errors.clear("additional_driver_name_first")')
            input-error-message(:errors='form.errors.get("additional_driver_name_first")')

        .input-container.two-fifths.fixed
          .input-block
            input.input-field#additional_driver_name_middle(
              type='text'
              placeholder='Middle'
              v-model='form.additional_driver.name_middle'
              v-error='form.errors.has("additional_driver_name_middle")'
              @input='form.errors.clear("additional_driver_name_middle")')
            input-error-message(:errors='form.errors.get("additional_driver_name_middle")')

      .input-container.two-fifths
        .input-block
          input.input-field#additional_driver_name_last(
            type='text'
            placeholder='Last'
            v-model='form.additional_driver.name_last'
            v-error='form.errors.has("additional_driver_name_last")'
            @input='form.errors.clear("additional_driver_name_last")')
          input-error-message(:errors='form.errors.get("additional_driver_name_last")')

    .input-container.whole
      .input-block
        label.input-label(for='additional_driver_license_number')
          | License
          span.input-label-note.right License must have a picture of the customer, or customer must have another picture ID.

      .input-container.two-fifths
        .input-block
          input.input-field#additional_driver_license_number(
            type='text'
            placeholder='Number: I12345678'
            v-model='form.additional_driver.license_number'
            v-error='form.errors.has("additional_driver_license_number")'
            @input='form.errors.clear("additional_driver_license_number")')
          input-error-message(:errors='form.errors.get("additional_driver_license_number")')

      .input-container.two-fifths
        .input-container.one-half.fixed
          .input-block
            input.input-field#additional_driver_license_state(
              type='text'
              placeholder='Issue State'
              v-model='form.additional_driver.license_state'
              v-error='form.errors.has("additional_driver_license_state")'
              @input='form.errors.clear("additional_driver_license_state")')
            input-error-message(:errors='form.errors.get("additional_driver_license_state")')

        .input-container.one-half.fixed
          .input-block
            input.input-field#additional_driver_license_country(
              disabled
              type='text'
              placeholder='Issue Country'
              v-model='form.additional_driver.license_country'
              v-error='form.errors.has("additional_driver_license_country")'
              @input='form.errors.clear("additional_driver_license_country")')
            input-error-message(:errors='form.errors.get("additional_driver_license_country")')

      .input-container.one-fifth
        .input-block
          input-date.input-field#additional_driver_license_expiration_date(
            placeholder='Expiration Date'
            v-model='form.additional_driver.license_expiration_date'
            v-error='form.errors.has("additional_driver_license_expiration_date")'
            @input='form.errors.clear("additional_driver_license_expiration_date")')
          input-error-message(:errors='form.errors.get("additional_driver_license_expiration_date")')

    .input-container.whole
      .input-block
        label.input-label(for='additional_driver_address_street1')
          | Address
          span.input-label-note.right Customer must have an actual home street address. DO NOT accept a POST OFFICE BOX as an address.

      .input-container.whole
        .input-block
          input.input-field#additional_driver_address_street1(
            type='text'
            placeholder='Address 1'
            v-model='form.additional_driver.address.street1'
            v-error='form.errors.has("additional_driver_address_street1")'
            @input='form.errors.clear("additional_driver_address_street1")')
          input-error-message(:errors='form.errors.get("additional_driver_address_street1")')

    .input-container.whole
      .input-container.whole
        .input-block
          input.input-field#additional_driver_address_street2(
            type='text'
            placeholder='Address 2'
            v-model='form.additional_driver.address.street2'
            v-error='form.errors.has("additional_driver_address_street2")'
            @input='form.errors.clear("additional_driver_address_street2")')
          input-error-message(:errors='form.errors.get("additional_driver_address_street2")')

    .input-container.whole
      .input-container.two-fifths
        .input-block
          input.input-field#additional_driver_address_city(
            type='text'
            placeholder='City'
            v-model='form.additional_driver.address.city'
            v-error='form.errors.has("additional_driver_address_city")'
            @input='form.errors.clear("additional_driver_address_city")')
          input-error-message(:errors='form.errors.get("additional_driver_address_city")')

      .input-container.three-fifths
        .input-container.two-thirds.fixed
          .input-block
            input.input-field#additional_driver_address_state(
              type='text'
              placeholder='State'
              v-model='form.additional_driver.address.state'
              v-error='form.errors.has("additional_driver_address_state")'
              @input='form.errors.clear("additional_driver_address_state")')
            input-error-message(:errors='form.errors.get("additional_driver_address_state")')

        .input-container.one-third.fixed
          .input-block
            input.input-field#additional_driver_address_zip_code(
              type='text'
              placeholder='Zip Code'
              v-model='form.additional_driver.address.zip_code'
              v-error='form.errors.has("additional_driver_address_zip_code")'
              @input='form.errors.clear("additional_driver_address_zip_code")')
            input-error-message(:errors='form.errors.get("additional_driver_address_zip_code")')

    .input-container.whole
      .input-container.one-half
        .input-block
          label.input-label(for='additional_driver_date_of_birth')
            | Date of Birth
            span.input-label-note.right Must be 25 years of age or older.
          input-date.input-field#additional_driver_date_of_birth(
            v-model='form.additional_driver.date_of_birth'
            v-error='form.errors.has("additional_driver_date_of_birth")'
            @input='form.errors.clear("additional_driver_date_of_birth")')
          input-error-message(:errors='form.errors.get("additional_driver_date_of_birth")')

      .input-container.one-half
        .input-block
          label.input-label(for='additional_driver_gender') Gender
          select.input-field#additional_driver_gender(
            v-model='form.additional_driver.gender'
            v-error='form.errors.has("additional_driver_gender")'
            @input='form.errors.clear("additional_driver_gender")')

            option(value='' disabled) ----
            option(value='male') Male
            option(value='female') Female
          input-error-message(:errors='form.errors.get("additional_driver_gender")')

    .input-container.whole
      .input-container.two-fifths
        .input-block
          label.input-label(for='additional_driver_email') Email
          input.input-field#additional_driver_email(
            type='text'
            placeholder='john@gmail.com'
            v-model='form.additional_driver.email'
            v-error='form.errors.has("additional_driver_email")'
            @input='form.errors.clear("additional_driver_email")')
          input-error-message(:errors='form.errors.get("additional_driver_email")')
      .input-container.three-fifths
        .input-container.one-half.fixed
          .input-block
            label.input-label(for='additional_driver_phone_numbers_cell') Cell Phone #
            input.input-field#additional_driver_phone_numbers_cell(
              type='text'
              placeholder='909.555.8639'
              v-model='form.additional_driver.phone_numbers.cell'
              v-error='form.errors.has("additional_driver_phone_numbers_cell")'
              @input='form.errors.clear("additional_driver_phone_numbers_cell")')
            input-error-message(:errors='form.errors.get("additional_driver_phone_numbers_cell")')
        .input-container.one-half.fixed
          .input-block
            label.input-label(for='additional_driver_phone_numbers_home') Home Phone #
            input.input-field#additional_driver_phone_numbers_home(
              type='text'
              placeholder='805.555.1234'
              v-model='form.additional_driver.phone_numbers.home'
              v-error='form.errors.has("additional_driver_phone_numbers_home")'
              @input='form.errors.clear("additional_driver_phone_numbers_home")')
            input-error-message(:errors='form.errors.get("additional_driver_phone_numbers_home")')
</template>
