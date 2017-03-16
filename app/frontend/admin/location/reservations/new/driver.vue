<script>
  import InputDateTime from 'Components/inputs/date_time'

  export default {
    components: {
      InputDateTime,
    }
  }

</script>

<template lang='pug'>
  .form-container
    h3.form-header.form-header-first Rental Dates
    .input-row
      .input-container.one-half
        label.input-label From:
        input-date-time

      .input-container.one-half
        label.input-label To:
        input-date-time

    h3.form-header Rates

    h3.form-header Driver
    .input-row
      label.input-label
        | Name
        a.right(href='') Search Driver
      .input-block.one-half.fixed
        input.input-field(type='text' placeholder='First')
      .input-block.one-half.fixed
        input.input-field(type='text' placeholder='Last')

    .input-row
      label.input-label
        | License
        span.input-label-note.right License must have a picture of the customer, or customer must have another picture ID.
      .input-block.two-fifths
        input.input-field(type='text' placeholder='Number: I12345678')
      .input-container.two-fifths
        .input-block.one-half.fixed
          input.input-field(type='text' placeholder='Issue State')
        .input-block.one-half.fixed
          input.input-field(type='text' placeholder='Issue Country')
      .input-block.one-fifth
          input.input-field(type='text' placeholder='Expiration Date')

      .input-row
        .input-container.one-half
          label.input-label
            | Date of Birth
            span.input-label-note.right Must be 25 years of age or older.
          .input-block.whole
            input.input-field(type='text' placeholder='mm/dd/yyyy')
        .input-container.one-half
          label.input-label Gender
          .input-block.whole
            select.input-field()
              option(value='' selected disabled) ----
              option(value='male') Male
              option(value='female') Female

      .input-row
        .input-container.two-fifths
          label.input-label Email
          .input-block.whole
            input.input-field(type='text' placeholder='john@gmail.com')
        .input-container.three-fifths
          .input-container.one-half.fixed
            label.input-label Cell Phone #
            .input-block.whole
              input.input-field(type='number' placeholder='909.555.8639')
          .input-container.one-half.fixed
            label.input-label Home Phone #
            .input-block.whole
              input.input-field(type='number' placeholder='805.555.1231')

      .input-row
        label.input-label
          | Address
          span.input-label-note.right Customer must have an actual home street address. DO NOT accept a POST OFFICE BOX as an address.
        .input-block.whole
          input.input-field(type='text' placeholder='Address 1')
      .input-row
        .input-block.whole
          input.input-field(type='text' placeholder='Address 2')
      .input-row
        .input-container.three-fifths
          .input-block.two-thirds.fixed
            input.input-field(type='text' placeholder='City')
          .input-block.one-third.fixed
            input.input-field(type='text' placeholder='State')
        .input-container.two-fifths
          .input-block.one-third.fixed
            input.input-field(type='Number' placeholder='Zip Code')
          .input-block.two-thirds.fixed
            input.input-field(type='text' placeholder='Country')

      .input-row
        .input-container.one-third
          label.input-label Insuance Company
          .input-block.whole
            input.input-field(type='text' placeholder='')
        .input-container.one-third
          label.input-label Insuance Policy #
          .input-block.whole
            input.input-field(type='text' placeholder='')
        .input-container.one-third
          label.input-label Insuance Phone #
          .input-block.whole
            input.input-field(type='number' placeholder='')


    h3.form-header
      a Add Additional Driver

    h3.form-header Summary

    h3.form-header Payments
    .input-row
      .input-container.two-fifths
        label.input-label Credit Card #
        .input-block.whole
          input.input-field(type='number' placeholder='4242 4242 4242 4242')
      .input-container.three-fifths
        .input-container.one-third.fixed
          label.input-label Expiration Date
          .input-block.three-sevenths.fixed
            select.input-field
              option(value='' selected disabled) --
              option(value='1') 01
              option(value='2') 02
              option(value='3') 03
              option(value='4') 04
              option(value='5') 05
              option(value='6') 06
              option(value='7') 07
              option(value='8') 08
              option(value='9') 09
              option(value='10') 10
              option(value='11') 11
              option(value='12') 12
          .input-block.four-sevenths.fixed
            select.input-field
              option(value='' selected disabled) ----
              option(value='17') 2017
              option(value='18') 2018
              option(value='19') 2019
              option(value='20') 2020
              option(value='21') 2021
              option(value='22') 2022
              option(value='23') 2023
              option(value='24') 2024
        .input-container.one-third.fixed
          label.input-label CVC Code
          .input-block.whole
            input.input-field(type='number' placeholder='123')
        .input-container.one-third.fixed
          label.input-label Zip Code
          .input-block.whole
            input.input-field(type='number' placeholder='90210')

</template>
