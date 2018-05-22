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
    .input-container.whole
      .input-container.one-half
        .input-block
          label.input-label Pickup
          input-date-time(v-model='pickup' disabled=true)

      .input-container.one-half
        .input-block
          label.input-label Drop-off
          input-date-time(
            v-model='form.drop_off'
            v-error='form.errors.has("drop_off")'
            @input='form.errors.clear("drop_off")')
          input-error-message(:errors='form.errors.get("drop_off")')

    .input-container.whole
      .input-block
        label.input-label(for='vehicle_type') Vehicle Type
        input-vehicle-types(
          v-model='form.vehicle_type'
          v-error='form.errors.has("vehicle_type")'
          @input='form.errors.clear("vehicle_type")')
        input-error-message(:errors='form.errors.get("vehicle_type")')

</template>
