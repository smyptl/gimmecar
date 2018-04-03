<script>
  import Dropdown from 'Components/dropdown'

  import ActionsIcon from 'Components/icons/actions'
  import VehicleInformation from 'Components/vehicle/information'

  import VehicleStatus from './vehicle/_status'

  export default {
    name: 'vehicle',
    data () {
      return {
        vehicle: {},
        change_status: false,
      }
    },
    components: {
      ActionsIcon,
      Dropdown,
      VehicleInformation,
      VehicleStatus,
    },
    created () {
      this.getData()
    },
    watch: {
      '$route': 'getData',
    },
    methods: {
      getData () {
        this.$http.get(this.$route.path).then(response => {
          this.vehicle = response.data
        })
      },
      statusChanged () {
        this.getData()
        this.change_status = false
      },
      changeStatus () {
        this.change_status = true
      },
    },
  }
</script>

<template lang='pug'>
  .panel.panel-base
    .panel-base-header
      h2 {{ vehicle.make_model }}
      dropdown.flex-element.right
        a.right(data-toggle='dropdown' href='#')
          actions-icon.action-icon
        .dropdown-menu.right(slot='dropdown-menu')
          ul
            li
              button.link(@click='changeStatus') Change Status

    vehicle-information(:vehicle='vehicle' :show_location='false')
    vehicle-status(v-on:close='statusChanged' v-if='change_status')

</template>

<style lang='stylus' scoped>

  .action-icon
    float: right
    height: 1.25rem

</style>
