<script>
  import Fuse from 'fuse.js'

  export default {
    name: 'Drivers',
    data() {
      return {
        drivers: {},
        search: '',
      }
    },
    created() {
      this.getData()
    },
    watch: {
      '$route': 'getData',
    },
    computed: {
      sortedDrivers() {
        if (this.search) {
          return new Fuse(this.drivers.data, {
            shouldSort: true,
            keys: ['name_full'],
          }).search(this.search)
        }

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
      .p-default
        input.input-field.input-contrast(type='text' v-model='search' placeholder='Search')

      table.panel-table.thead-bt
        thead
          tr
            th Name
            th
        tbody
          tr.clickable(
            v-for='driver in sortedDrivers'
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
    border-radius: $border-radius-default

    font-weight: 700
    color: #ffffff

</style>
