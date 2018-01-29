<script>
  export default {
    props: {
      driver: {
        required: true,
        type: Object,
      },
    },
  }
</script>

<template lang='pug'>
  table.panel-table.panel-table-key-pair
    tbody
      tr
        td Name
        td {{ driver.name_first }} {{ driver.name_middle }} {{ driver.name_last }}
      tr
        td Email
        td {{ driver.email }}
      tr
        td Cell Phone #
        td
          a(v-bind:href="'tel:' + driver.cell_phone_number") {{ driver.cell_phone_number }}
      tr(v-if='driver.home_phone_number')
        td Home Phone #
        td
          a(v-bind:href="'tel:' + driver.home_phone_number") {{ driver.home_phone_number }}
      tr
        td Address
        td
          address
            .block {{ driver.address_1 }}
            .block(v-if='driver.address_2') {{ driver.address_2 }}
            .block {{ driver.city }}, {{ driver.state }} {{ driver.zip_code }}

</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/table'

</style>
