<script>
  export default {
    name: 'Dashboard',
    created() {
      this.$router.push({ name: 'rentals' })
    },
  }
</script>

<template lang='pug'>
  h1 Dashboard
</template>
