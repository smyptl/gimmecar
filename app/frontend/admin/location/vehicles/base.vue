<script>
  export default {
    name: 'vehicles',
  }
</script>

<template lang='pug'>
  div
    router-link(:to="{ name: 'vehicles' }")
      h4.margin-bottom-default Vehicles
    router-view
</template>
