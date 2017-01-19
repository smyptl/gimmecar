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
    h4.form-header.form-header-first Rental Dates
    .input-row
      .input-container.one-half
        label.input-label From:
        input-date-time

      .input-container.one-half
        label.input-label To:
        input-date-time

    .input-submit.input-block
      button.btn.btn-primary.right Rates

</template>
