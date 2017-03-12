<script>
  export default {
    name: 'rentals',
  }
</script>

<template lang='pug'>
  div
    router-link(:to="{ name: 'rentals' }")
      h4.margin-bottom-default Rentals
    router-view
</template>
