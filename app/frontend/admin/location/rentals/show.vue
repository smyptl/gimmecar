<script>
  export default {
    name: 'rental',
    data () {
      return {
        rental: {},
      }
    },
    created () {
      this.fetchData()
    },
    watch: {
      '$route': 'fetchData',
    },
    methods: {
      fetchData () {
        this.$http
          .get(this.$route.path)
          .then(response => {
            this.rental = response.data
        })
      },
    },
  }
</script>

<template lang='pug'>
  div
    h2 # {{ this.$route.params.number }}

    p {{ rental }}
</template>

<style lang='stylus' scoped>
</style>
