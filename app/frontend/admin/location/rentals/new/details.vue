<script>
  import Shake from 'Utils/transitions/shake'
  import InputVehicleTypes from 'Components/inputs/vehicle_types'
  import InputDateTime from 'Components/inputs/date_time'

  export default {
    name: 'Details',
    props: {
      form: {
        type: Object,
        required: true,
      },
    },
    components: {
      InputDateTime,
      InputVehicleTypes,
    },
  }
</script>

<template lang='pug'>
  div
    .input-row
      .input-container.one-half
        label.input-label Pickup
        .input-block.whole
          input-date-time(v-model='pickup' disabled=true)

      .input-container.one-half
        label.input-label Drop-off
        .input-block.whole
          input-date-time(
            v-model='form.drop_off'
            v-error='form.errors.has("drop_off")'
            @input='form.errors.clear("drop_off")')
        input-error-message(:errors='form.errors.get("drop_off")')

    .input-row
      label.input-label(for='vehicle_type') Vehicle Type
      .input-block.whole
        input-vehicle-types(
          v-model='form.vehicle_type'
          v-error='form.errors.has("vehicle_type")'
          @input='form.errors.clear("vehicle_type")')

      input-error-message(:errors='form.errors.get("vehicle_type")')

</template>
