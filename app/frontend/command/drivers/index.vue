<script>
  export default {
    name: 'Drivers',
    data() {
      return {
        drivers: {},
      }
    },
    created() {
      this.getData()
    },
    watch: {
      '$route': 'getData',
    },
    computed: {
      sorted_drivers() {
        return this.drivers.data
      },
    },
    methods: {
      getData() {
        this.$http
          .get(this.$route.path)
          .then(response => {
            this.drivers = response.data
        })
      },
      viewDriver(id) {
        this.$router.push({ name: 'driver', params: { id: id } })
      },
    },
  }
</script>

<template lang='pug'>
  .panel.panel-base
    .gimmecar-app-vertical-scroll
      table.panel-table
        thead
          tr
            th Name
            th
        tbody
          tr.clickable(
            v-for='driver in sorted_drivers'
            :key='driver.id'
            @click.prevent='viewDriver(driver.id)'
          )

            td {{ driver.name_full }}
            td.text-right
              span.dnr.font-mono(v-if='driver.do_not_rent') DNR
</template>

<style lang='stylus' scoped>
  @import '~Styles/global/colors'
  @import '~Styles/global/layout'
  @import '~Styles/components/panels/table'

  .dnr
    padding: $padding-ex-sm

    background: $red
    border-radius: 0.125rem

    font-weight: 700
    color: #ffffff

</style>
