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
      label.input-label
        | Name
        a.right(href='') Search Driver
      .input-block.one-half.fixed
        input.input-field(type='text' v-model='form.driver.first_name' placeholder='First')
      .input-block.one-half.fixed
        input.input-field(type='text' v-model='form.driver.last_name' placeholder='Last')

    .input-row
      label.input-label
        | License
        span.input-label-note.right License must have a picture of the customer, or customer must have another picture ID.
      .input-block.two-fifths
        input.input-field(type='text' v-model='form.driver.license_number' placeholder='Number: I12345678')
      .input-container.two-fifths
        .input-block.one-half.fixed
          input.input-field(type='text' v-model='form.driver.license_state' placeholder='Issue State')
        .input-block.one-half.fixed
          input.input-field(type='text' v-model='form.driver.license_country' placeholder='Issue Country')
      .input-block.one-fifth
          input.input-field(type='text' v-model='form.driver.license_expiration_date' placeholder='Expiration Date')

    .input-row
      label.input-label
        | Address
        span.input-label-note.right Customer must have an actual home street address. DO NOT accept a POST OFFICE BOX as an address.
      .input-block.whole
        input.input-field(type='text' v-model='form.driver.address_1' placeholder='Address 1')
    .input-row
      .input-block.whole
        input.input-field(type='text' v-model='form.driver.address_2' placeholder='Address 2')
    .input-row
      .input-container.three-fifths
        .input-block.two-thirds.fixed
          input.input-field(type='text' v-model='form.driver.city' placeholder='City')
        .input-block.one-third.fixed
          input.input-field(type='text' v-model='form.driver.state' placeholder='State')
      .input-container.two-fifths
        .input-block.one-third.fixed
          input.input-field(type='number' v-model='form.driver.zip_code' placeholder='Zip Code')
        .input-block.two-thirds.fixed
          input.input-field(type='text' v-model='form.driver.country' placeholder='Country')

    .input-row
      .input-container.one-half
        label.input-label
          | Date of Birth
          span.input-label-note.right Must be 25 years of age or older.
        .input-block.whole
          input.input-field(type='text' v-model='form.driver.date_of_birth' placeholder='mm/dd/yyyy')
      .input-container.one-half
        label.input-label Gender
        .input-block.whole
          select.input-field(v-model='form.driver.gender')
            option(value='' disabled) ----
            option(value='male') Male
            option(value='female') Female

    .input-row
      .input-container.two-fifths
        label.input-label Email
        .input-block.whole
          input.input-field(type='text' v-model='form.driver.email' placeholder='john@gmail.com')
      .input-container.three-fifths
        .input-container.one-half.fixed
          label.input-label Cell Phone #
          .input-block.whole
            input.input-field(type='number' v-model='form.driver.cell_phone_number' placeholder='909.555.8639')
        .input-container.one-half.fixed
          label.input-label Home Phone #
          .input-block.whole
            input.input-field(type='number' v-model='form.driver.home_phone_number' placeholder='805.555.1231')

    .input-row
      label.input-label Insuance
      .input-container.two-fifths
        .input-block.whole
          input.input-field(type='text' placeholder='Company Name')
      .input-container.three-fifths
        .input-block.two-thirds.fixed
          input.input-field(type='text' placeholder='Policy #')
        .input-block.one-third.fixed
          input.input-field(type='text' placeholder='Expiration Date')
    .input-row
      .input-container.one-half.fixed
        .input-block.whole
          input.input-field(type='text' placeholder='Agent / Representative / Adjustor')
      .input-container.one-half.fixed
        .input-block.whole
          input.input-field(type='number' placeholder='Phone #')

    h4.form-header
      a.link-danger(v-if='form.add_additional_driver' @click='form.add_additional_driver = false') Remove Additional Driver
      a(v-else @click='form.add_additional_driver = true') Add Additional Driver

    template(v-if='form.add_additional_driver')
      .input-row
        label.input-label
          | Name
          a.right(href='') Search Driver
        .input-block.one-half.fixed
          input.input-field(type='text' v-model='form.additional_driver.first_name' placeholder='First')
        .input-block.one-half.fixed
          input.input-field(type='text' v-model='form.additional_driver.last_name' placeholder='Last')

      .input-row
        label.input-label
          | License
          span.input-label-note.right License must have a picture of the customer, or customer must have another picture ID.
        .input-block.two-fifths
          input.input-field(type='text' v-model='form.additional_driver.license_number' placeholder='Number: I12345678')
        .input-container.two-fifths
          .input-block.one-half.fixed
            input.input-field(type='text' v-model='form.additional_driver.license_state' placeholder='Issue State')
          .input-block.one-half.fixed
            input.input-field(type='text' v-model='form.additional_driver.license_country' placeholder='Issue Country')
        .input-block.one-fifth
            input.input-field(type='text' v-model='form.additional_driver.license_expiration_date' placeholder='Expiration Date')

      .input-row
        label.input-label
          | Address
          span.input-label-note.right Customer must have an actual home street address. DO NOT accept a POST OFFICE BOX as an address.
        .input-block.whole
          input.input-field(type='text' v-model='form.additional_driver.address_1' placeholder='Address 1')
      .input-row
        .input-block.whole
          input.input-field(type='text' v-model='form.additional_driver.address_2' placeholder='Address 2')
      .input-row
        .input-container.three-fifths
          .input-block.two-thirds.fixed
            input.input-field(type='text' v-model='form.additional_driver.city' placeholder='City')
          .input-block.one-third.fixed
            input.input-field(type='text' v-model='form.additional_driver.state' placeholder='State')
        .input-container.two-fifths
          .input-block.one-third.fixed
            input.input-field(type='number' v-model='form.additional_driver.zip_code' placeholder='Zip Code')
          .input-block.two-thirds.fixed
            input.input-field(type='text' v-model='form.additional_driver.country' placeholder='Country')

      .input-row
        .input-container.one-half
          label.input-label
            | Date of Birth
            span.input-label-note.right Must be 25 years of age or older.
          .input-block.whole
            input.input-field(type='text' v-model='form.additional_driver.date_of_birth' placeholder='mm/dd/yyyy')
        .input-container.one-half
          label.input-label Gender
          .input-block.whole
            select.input-field(v-model='form.additional_driver.gender')
              option(value='' disabled) ----
              option(value='male') Male
              option(value='female') Female

      .input-row
        .input-container.two-fifths
          label.input-label Email
          .input-block.whole
            input.input-field(type='text' v-model='form.additional_driver.email' placeholder='john@gmail.com')
        .input-container.three-fifths
          .input-container.one-half.fixed
            label.input-label Cell Phone #
            .input-block.whole
              input.input-field(type='number' v-model='form.additional_driver.cell_phone_number' placeholder='909.555.8639')
          .input-container.one-half.fixed
            label.input-label Home Phone #
            .input-block.whole
              input.input-field(type='number' v-model='form.additional_driver.home_phone_number' placeholder='805.555.1231')

</template>
