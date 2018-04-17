<script>
  import VehicleTable from 'Components/vehicle/table'

  export default {
    name: 'Vehicles',
    data () {
      return {
        vehicles: {},
      }
    },
    created () {
      this.getData()
    },
    components: {
      VehicleTable,
    },
    watch: {
      '$route': 'getData',
    },
    methods: {
      getData () {
        this.$http
          .get(this.$route.path)
          .then(response => {
            this.vehicles = response.data
        })
      },
      viewVehicle (vin) {
        this.$router.push({ name: 'vehicle', params: { vin: vin }})
      },
    },
  }
</script>

<template lang='pug'>
  vehicle-table(:vehicles='vehicles'
                :show_location='false'
                @view-vehicle='viewVehicle($event)')
</template>
