<script>
  import RentalsTable from 'Components/rental/table'

  export default {
    name: 'Rentals',
    data () {
      return {
        rentals: [],
      }
    },
    components: {
      RentalsTable,
    },
    created () {
      this.getData()
    },
    watch: {
      '$route': 'getData',
    },
    methods: {
      getData () {
        this.$http
          .get(this.$route.path)
          .then(response => {
            this.rentals = response.data
        })
      },
      viewRental (number) {
        this.$router.push({ name: 'rental', params: { number: number }})
      },
    },
  }
</script>

<template lang='pug'>
  rentals-table(:rentals='rentals' :show_location='false' v-on:view-rental='viewRental($event)')
</template>
