<script>
  export default {
    props: {
      form: {
        type: Object,
        required: true,
      },
    },
  }

</script>

<template lang='pug'>
  div
    .input-row
      label.input-label(for='driver_first_name')
        | Name
        a.right(href='') Search Driver
      .input-block.one-half.fixed
        input.input-field#driver_first_name(type='text' v-model='form.driver.first_name' placeholder='First')
      .input-block.one-half.fixed
        input.input-field#driver_last_name(type='text' v-model='form.driver.last_name' placeholder='Last')

    .input-row
      label.input-label(for='license_number')
        | License
        span.input-label-note.right License must have a picture of the customer, or customer must have another picture ID.
      .input-block.two-fifths
        input.input-field#driver_license_number(type='text' v-model='form.driver.license_number' placeholder='Number: I12345678')
      .input-container.two-fifths
        .input-block.one-half.fixed
          input.input-field#driver_license_state(type='text' v-model='form.driver.license_state' placeholder='Issue State')
        .input-block.one-half.fixed
          input.input-field#driver_license_country(type='text' v-model='form.driver.license_country' placeholder='Issue Country')
      .input-block.one-fifth
          input.input-field#driver_license_expiration_date(type='text' v-model='form.driver.license_expiration_date' placeholder='Expiration Date')

    .input-row
      label.input-label(for='driver_address_1')
        | Address
        span.input-label-note.right Customer must have an actual home street address. DO NOT accept a POST OFFICE BOX as an address.
      .input-block.whole
        input.input-field#driver_address_1(type='text' v-model='form.driver.address_1' placeholder='Address 1')
    .input-row
      .input-block.whole
        input.input-field#driver_address_2(type='text' v-model='form.driver.address_2' placeholder='Address 2')
    .input-row
      .input-container.three-fifths
        .input-block.two-thirds.fixed
          input.input-field#driver_city(type='text' v-model='form.driver.city' placeholder='City')
        .input-block.one-third.fixed
          input.input-field#driver_state(type='text' v-model='form.driver.state' placeholder='State')
      .input-container.two-fifths
        .input-block.one-third.fixed
          input.input-field#driver_zip_code(type='number' v-model='form.driver.zip_code' placeholder='Zip Code')
        .input-block.two-thirds.fixed
          input.input-field#driver_country(type='text' v-model='form.driver.country' placeholder='Country')

    .input-row
      .input-container.one-half
        label.input-label(for='driver_date_of_birth')
          | Date of Birth
          span.input-label-note.right Must be 25 years of age or older.
        .input-block.whole
          input.input-field#driver_date_of_birth(type='text' v-model='form.driver.date_of_birth' placeholder='mm/dd/yyyy')
      .input-container.one-half
        label.input-label(for='driver_gender') Gender
        .input-block.whole
          select.input-field#driver_gender(v-model='form.driver.gender')
            option(value='' disabled) ----
            option(value='male') Male
            option(value='female') Female

    .input-row
      .input-container.two-fifths
        label.input-label(for='driver_email') Email
        .input-block.whole
          input.input-field#driver_email(type='text' v-model='form.driver.email' placeholder='john@gmail.com')
      .input-container.three-fifths
        .input-container.one-half.fixed
          label.input-label(for='driver_cell_phone_number') Cell Phone #
          .input-block.whole
            input.input-field#driver_cell_phone_number(type='number' v-model='form.driver.cell_phone_number' placeholder='909.555.8639')
        .input-container.one-half.fixed
          label.input-label(for='driver_home_phone_number') Home Phone #
          .input-block.whole
            input.input-field#driver_home_phone_number(type='number' v-model='form.driver.home_phone_number' placeholder='805.555.1231')

    .input-row
      label.input-label Insuance
      .input-container.two-fifths
        .input-block.whole
          input.input-field#driver_insurance_company_name(type='text' v-model='form.driver.insurance.company_name' placeholder='Company Name')
      .input-container.three-fifths
        .input-block.one-third.fixed
          input.input-field#driver_insurance_policy_number(type='text' v-model='form.driver.insurance.policy_number' placeholder='Policy #')
        .input-block.one-third.fixed
          input.input-field#driver_insurance_effective_date(type='text' v-model='form.driver.insurance.effective_date' placeholder='Effective Date')
        .input-block.one-third.fixed
          input.input-field#driver_insurance_expiration_date(type='text' v-model='form.driver.insurance.expiration_date' placeholder='Expiration Date')
    .input-row
      .input-container.one-half.fixed
        .input-block.whole
          input.input-field#driver_insurance_agent_name(type='text' v-model='form.driver.insurance.agent_name' placeholder='Agent / Representative / Adjustor')
      .input-container.one-half.fixed
        .input-block.whole
          input.input-field#driver_insurance_phone_number(type='number' v-model='form.driver.insurance.phone_number' placeholder='Phone #')

    h4.form-header
      a.link-danger(v-if='form.add_additional_driver' @click='form.add_additional_driver = false') Remove Additional Driver
      a(v-else @click='form.add_additional_driver = true') Add Additional Driver

    template(v-if='form.add_additional_driver')
      .input-row
        label.input-label(for='additional_driver_first_name')
          | Name
          a.right(href='') Search Driver
        .input-block.one-half.fixed
          input.input-field#additional_driver_first_name(type='text' v-model='form.additional_driver.first_name' placeholder='First')
        .input-block.one-half.fixed
          input.input-field#additional_driver_last_name(type='text' v-model='form.additional_driver.last_name' placeholder='Last')

      .input-row
        label.input-label(for='additional_driver_license_number')
          | License
          span.input-label-note.right License must have a picture of the customer, or customer must have another picture ID.
        .input-block.two-fifths
          input.input-field#additional_driver_license_number(type='text' v-model='form.additional_driver.license_number' placeholder='Number: I12345678')
        .input-container.two-fifths
          .input-block.one-half.fixed
            input.input-field#additional_driver_license_state(type='text' v-model='form.additional_driver.license_state' placeholder='Issue State')
          .input-block.one-half.fixed
            input.input-field#additional_driver_license_country(type='text' v-model='form.additional_driver.license_country' placeholder='Issue Country')
        .input-block.one-fifth
            input.input-field#additional_driver_license_expiration_date(type='text' v-model='form.additional_driver.license_expiration_date' placeholder='Expiration Date')

      .input-row
        label.input-label(for='additional_driver_address_1')
          | Address
          span.input-label-note.right Customer must have an actual home street address. DO NOT accept a POST OFFICE BOX as an address.
        .input-block.whole
          input.input-field#additional_driver_address_1(type='text' v-model='form.additional_driver.address_1' placeholder='Address 1')
      .input-row
        .input-block.whole
          input.input-field#additional_driver_address_2(type='text' v-model='form.additional_driver.address_2' placeholder='Address 2')
      .input-row
        .input-container.three-fifths
          .input-block.two-thirds.fixed
            input.input-field#additional_driver_city(type='text' v-model='form.additional_driver.city' placeholder='City')
          .input-block.one-third.fixed
            input.input-field#additional_driver_state(type='text' v-model='form.additional_driver.state' placeholder='State')
        .input-container.two-fifths
          .input-block.one-third.fixed
            input.input-field#additional_driver_zip_code(type='number' v-model='form.additional_driver.zip_code' placeholder='Zip Code')
          .input-block.two-thirds.fixed
            input.input-field#additional_driver_country(type='text' v-model='form.additional_driver.country' placeholder='Country')

      .input-row
        .input-container.one-half
          label.input-label(for='additional_driver_date_of_birth')
            | Date of Birth
            span.input-label-note.right Must be 25 years of age or older.
          .input-block.whole
            input.input-field#additional_driver_date_of_birth(type='text' v-model='form.additional_driver.date_of_birth' placeholder='mm/dd/yyyy')
        .input-container.one-half
          label.input-label(for='additional_driver_gender') Gender
          .input-block.whole
            select.input-field#additional_driver_gender(v-model='form.additional_driver.gender')
              option(value='' disabled) ----
              option(value='male') Male
              option(value='female') Female

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
