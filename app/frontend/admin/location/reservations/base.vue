<script>
  export default {
    name: 'reservations',
  }
</script>

<template lang='pug'>
  div
    router-link(:to="{ name: 'reservations' }")
      h4.margin-bottom-default Reservations
    router-view
</template>
