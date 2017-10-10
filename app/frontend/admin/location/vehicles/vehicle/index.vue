<script>
  import FDate from 'Filters/date'
  import FDateTime from 'Filters/date_time'
  import Capitalize from 'lodash/capitalize'

  import Dropdown from 'Components/dropdown'

  import ActionsIcon from 'Components/icons/actions'

  export default {
    name: 'vehicle',
    data () {
      return {
        vehicle: {},
      }
    },
    filters: {
      date: FDate,
      date_time: FDateTime,
      Capitalize,
    },
    components: {
      ActionsIcon,
      Dropdown,
    },
    created () {
      this.fetchData()
    },
    watch: {
      '$route': 'fetchData',
    },
    methods: {
      fetchData () {
        this.$http.get(this.$route.path).then(response => {
          this.vehicle = response.data
        })
      },
    },
  }
</script>

<template lang='pug'>
  div
    .panel.panel-base
      .panel-base-header
        h2 {{ vehicle.make }} {{ vehicle.model }}
        <!--dropdown.flex-element.right-->
          <!--a(data-toggle='dropdown')-->
            <!--actions-icon.action-icon-->
          <!--.dropdown-menu.right(slot='dropdown-menu')-->
            <!--ul-->
              <!--li-->
                <!--button.link Print Invoice-->

      dl.panel-main-details
        dt Type
        dd {{ vehicle.vehicle_type }}
        template(v-if='vehicle.license_number')
          dt License Number
          dd {{ vehicle.license_number }}
        dt Vin
        dd {{ vehicle.vin }}
        dt Year
        dd {{ vehicle.year }}
        dt Color
        dd {{ vehicle.color | capitalize }}

</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/details'

  .action-icon
    float: right
    height: 1.25rem

</style>
