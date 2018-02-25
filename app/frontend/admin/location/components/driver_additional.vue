<script>
  import InputDate from 'Components/inputs/date'

  export default {
    name: 'driver_additional',
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
    .input-row
      label.input-label(for='additional_driver_name_first') Name
      .input-container.three-fifths
        .input-container.three-fifths.fixed
          .input-block.whole
            input.input-field#additional_driver_name_first(
              type='text'
              placeholder='First'
              v-model='form.additional_driver.name_first'
              v-error='form.errors.has("additional_driver_name_first")'
              @input='form.errors.clear("additional_driver_name_first")')
          input-error-message(v-bind:errors='form.errors.get("additional_driver_name_first")')

        .input-container.two-fifths.fixed
          .input-block.whole
            input.input-field#additional_driver_name_middle(
              type='text'
              placeholder='Middle'
              v-model='form.additional_driver.name_middle'
              v-error='form.errors.has("additional_driver_name_middle")'
              @input='form.errors.clear("additional_driver_name_middle")')
          input-error-message(v-bind:errors='form.errors.get("additional_driver_name_middle")')

      .input-container.two-fifths
        .input-block.whole
          input.input-field#additional_driver_name_last(
            type='text'
            placeholder='Last'
            v-model='form.additional_driver.name_last'
            v-error='form.errors.has("additional_driver_name_last")'
            @input='form.errors.clear("additional_driver_name_last")')
          input-error-message(v-bind:errors='form.errors.get("additional_driver_name_last")')

    .input-row
      label.input-label(for='additional_driver_license_number')
        | License
        span.input-label-note.right License must have a picture of the customer, or customer must have another picture ID.

      .input-container.two-fifths
        .input-block.whole
          input.input-field#additional_driver_license_number(
            type='text'
            placeholder='Number: I12345678'
            v-model='form.additional_driver.license_number'
            v-error='form.errors.has("additional_driver_license_number")'
            @input='form.errors.clear("additional_driver_license_number")')
        input-error-message(v-bind:errors='form.errors.get("additional_driver_license_number")')

      .input-container.two-fifths
        .input-container.one-half.fixed
          .input-block.whole
            input.input-field#additional_driver_license_state(
              type='text'
              placeholder='Issue State'
              v-model='form.additional_driver.license_state'
              v-error='form.errors.has("additional_driver_license_state")'
              @input='form.errors.clear("additional_driver_license_state")')
          input-error-message(v-bind:errors='form.errors.get("additional_driver_license_state")')

        .input-container.one-half.fixed
          .input-block.whole
            input.input-field#additional_driver_license_country(
              type='text'
              placeholder='Issue Country'
              v-model='form.additional_driver.license_country'
              v-error='form.errors.has("additional_driver_license_country")'
              @input='form.errors.clear("additional_driver_license_country")')
          input-error-message(v-bind:errors='form.errors.get("additional_driver_license_country")')

      .input-container.one-fifth
        .input-block.whole
          input-date.input-field#additional_driver_license_expiration_date(
            placeholder='Expiration Date'
            v-model='form.additional_driver.license_expiration_date'
            v-error='form.errors.has("additional_driver_license_expiration_date")'
            @input='form.errors.clear("additional_driver_license_expiration_date")')
        input-error-message(v-bind:errors='form.errors.get("additional_driver_license_expiration_date")')

    .input-row
      label.input-label(for='additional_driver_address_1')
        | Address
        span.input-label-note.right Customer must have an actual home street address. DO NOT accept a POST OFFICE BOX as an address.

      .input-container.whole
        .input-block.whole
          input.input-field#additional_driver_address_1(
            type='text'
            placeholder='Address 1'
            v-model='form.additional_driver.address_1'
            v-error='form.errors.has("additional_driver_address_1")'
            @input='form.errors.clear("additional_driver_address_1")')
        input-error-message(v-bind:errors='form.errors.get("additional_driver_address_1")')

    .input-row
      .input-container.whole
        .input-block.whole
          input.input-field#additional_driver_address_2(
            type='text'
            placeholder='Address 2'
            v-model='form.additional_driver.address_2'
            v-error='form.errors.has("additional_driver_address_2")'
            @input='form.errors.clear("additional_driver_address_2")')
        input-error-message(v-bind:errors='form.errors.get("additional_driver_address_2")')

    .input-row
      .input-container.three-fifths
        .input-container.two-thirds.fixed
          .input-block.whole
            input.input-field#additional_driver_city(
              type='text'
              placeholder='City'
              v-model='form.additional_driver.city'
              v-error='form.errors.has("additional_driver_city")'
              @input='form.errors.clear("additional_driver_city")')
          input-error-message(v-bind:errors='form.errors.get("additional_driver_city")')

        .input-container.one-third.fixed
          .input-block.whole
            input.input-field#additional_driver_state(
              type='text'
              placeholder='State'
              v-model='form.additional_driver.state'
              v-error='form.errors.has("additional_driver_state")'
              @input='form.errors.clear("additional_driver_state")')
          input-error-message(v-bind:errors='form.errors.get("additional_driver_state")')

      .input-container.two-fifths
        .input-container.one-third.fixed
          .input-block.whole
            input.input-field#additional_driver_zip_code(
              type='text'
              placeholder='Zip Code'
              v-model='form.additional_driver.zip_code'
              v-error='form.errors.has("additional_driver_zip_code")'
              @input='form.errors.clear("additional_driver_zip_code")')
          input-error-message(v-bind:errors='form.errors.get("additional_driver_zip_code")')

        .input-container.two-thirds.fixed
          .input-block.whole
            input.input-field#additional_driver_country(
              type='text'
              placeholder='Country'
              v-model='form.additional_driver.country'
              v-error='form.errors.has("additional_driver_country")'
              @input='form.errors.clear("additional_driver_country")')
          input-error-message(v-bind:errors='form.errors.get("additional_driver_country")')

    .input-row
      .input-container.one-half
        label.input-label(for='additional_driver_date_of_birth')
          | Date of Birth
          span.input-label-note.right Must be 25 years of age or older.
        .input-block.whole
          input-date.input-field#additional_driver_date_of_birth(
            v-model='form.additional_driver.date_of_birth'
            v-error='form.errors.has("additional_driver_date_of_birth")'
            @input='form.errors.clear("additional_driver_date_of_birth")')
        input-error-message(v-bind:errors='form.errors.get("additional_driver_date_of_birth")')

      .input-container.one-half
        label.input-label(for='additional_driver_gender') Gender
        .input-block.whole
          select.input-field#additional_driver_gender(
            v-model='form.additional_driver.gender'
            v-error='form.errors.has("additional_driver_gender")'
            @input='form.errors.clear("additional_driver_gender")')

            option(value='' disabled) ----
            option(value='male') Male
            option(value='female') Female
        input-error-message(v-bind:errors='form.errors.get("additional_driver_gender")')

    .input-row
      .input-container.two-fifths
        label.input-label(for='additional_driver_email') Email
        .input-block.whole
          input.input-field#additional_driver_email(type='text' v-model='form.additional_driver.email' placeholder='john@gmail.com')
      .input-container.three-fifths
        .input-container.one-half.fixed
          label.input-label(for='additional_driver_cell_phone_number') Cell Phone #
          .input-block.whole
            input.input-field#additional_driver_cell_phone_number(type='number' v-model='form.additional_driver.cell_phone_number' placeholder='909.555.8639')
        .input-container.one-half.fixed
          label.input-label(for='additional_driver_home_phone_number') Home Phone #
          .input-block.whole
            input.input-field#additional_driver_home_phone_number(type='number' v-model='form.additional_driver.home_phone_number' placeholder='805.555.1231')
</template>
