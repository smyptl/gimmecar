<script>
  import X from 'Components/icons/cancel.vue'
  import C from 'Components/icons/check.vue'

  export default {
    name: 'index',
    data () {
      return {
        vehicles: [],
      }
    },
    created () {
      this.fetchData()
    },
    components: {
      X,
      C,
    },
    watch: {
      '$route': 'fetchData',
    },
    methods: {
      fetchData () {
        this.$http
          .get(this.$route.path)
          .then(response => {
            this.vehicles = response.data
        })
      },
    },
  }
</script>

<template lang='pug'>
  .panel.panel-base.whole
    table.panel-table
      thead
        tr
          th Vehicle
          th Type
          th License #
          th Available
      tbody.alternate-color
        tr.clickable(v-for='vehicle in vehicles')
          td {{ vehicle.make_model }}
          td {{ vehicle.vehicle_type }}
          td {{ vehicle.license_number }}
          td.status
            svg.text-success(v-if='vehicle.available' xlmns='http://www.w3.org/2000/svg' viewBox='-100 100 800 800' preserveAspectRatio='xMinYMin')
              path(d='M248.8 850q-34 0 -56 -28l-180 -236q-16 -24 -12 -52t26 -46 51 -14 47 28l118 154 296 -474q16 -24 43 -30t53 8q24 16 30 43t-8 53l-350 560q-20 32 -56 32z')
            svg.text-danger(v-else xlmns='http://www.w3.org/2000/svg' viewBox='-100 150 700 700' preserveAspectRatio='xMinYMin')
              path(d='M452 656q18 18 18 43t-18 43q-18 16 -43 16t-43 -16l-132 -152 -132 152q-18 16 -43 16t-43 -16q-16 -18 -16 -43t16 -43l138 -156 -138 -158q-16 -18 -16 -43t16 -43q18 -16 43 -16t43 16l132 152 132 -152q18 -16 43 -16t43 16q18 18 18 43t-18 43l-138 158z')
</template>

<style lang='stylus' scoped>

  .status
    vertical-align: center

    svg
      height: 0.75rem

</style>
