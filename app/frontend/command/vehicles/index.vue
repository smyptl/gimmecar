<script>
  import VehicleTable from 'Components/vehicle/table'

  export default {
    name: 'Vehicles',
    data () {
      return {
        vehicles: {},
      }
    },
    components: {
      VehicleTable,
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
                @view-vehicle='viewVehicle($event)')
</template>
