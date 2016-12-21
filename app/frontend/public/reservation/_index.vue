<script>
  import RentalDetails from './_rental_details.vue'

  export default {
    name: "reservation",
    components: {
      RentalDetails,
    },
  }
</script>

<template lang='pug'>
  #billboard-reservation-inputs
    rental-details

</template>
