<script>
  import Dropdown from 'Components/dropdown'
  import ActionsIcon from 'Components/icons/actions'
  import VehicleInformation from 'Components/vehicle/information'

  export default {
    name: 'vehicle',
    data () {
      return {
        vehicle: {},
      }
    },
    components: {
      ActionsIcon,
      Dropdown,
      VehicleInformation,
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
    },
  }
</script>

<template lang='pug'>
  .panel.panel-base
    .panel-base-header
      h2 {{ vehicle.make }} {{ vehicle.model }}
      <!--dropdown.flex-element.right-->
        <!--a(data-toggle='dropdown')-->
          <!--actions-icon.action-icon-->
        <!--.dropdown-menu.right(slot='dropdown-menu')-->
          <!--ul-->
            <!--li-->
              <!--button.link(@click='changeStatus') Change Status-->

    vehicle-information(v-bind:vehicle='vehicle')

</template>

<style lang='stylus' scoped>

  .action-icon
    float: right
    height: 1.25rem

</style>
