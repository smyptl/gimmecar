<script>
  import AddressFormat from 'Components/address'
  import PhoneFormat   from 'Components/phone_number'
  import Capitalize    from 'lodash/capitalize'
  import TDate         from 'Filters/date'

  export default {
    name: 'Information',
    props: {
      driver: {
        required: true,
        type: Object,
      },
    },
    components: {
      AddressFormat,
      PhoneFormat,
    },
    filters: {
      Capitalize,
      date: TDate,
    },
  }
</script>

<template lang='pug'>
  div
    p.dnr.font-mono(v-if='driver.do_not_rent') DO NOT RENT!!!

    table.panel-table.panel-table-key-pair.thead-bt
      tbody
        tr
          td Full Name
          td {{ driver.name_first }} {{ driver.name_middle }} {{ driver.name_last }}

    table.panel-table.panel-table-key-pair.thead-bt
      thead
        tr
          th Contact Info
          th
      tbody
        tr
          td Email
          td {{ driver.email }}
        tr(v-for='phone in driver.phone_numbers' :key='phone.id')
          td {{ phone.phone_type | capitalize }} Phone #
          td
            phone-format(:phone='phone')
        tr(v-for='address in driver.addresses' :key='address.id')
          td {{ address.address_type | capitalize }} Address
          td
            address-format(:address='address')

    table.panel-table.panel-table-key-pair.thead-bt
      thead
        tr
          th License
          th
      tbody
        tr
          td License #
          td {{ driver.license_number }}
        tr
          td State
          td {{ driver.license_state }}
        tr
          td Expiration Date
          td {{ driver.license_expiration_date | date }}
        tr
          td Gender
          td
            span.gender-icon.mr-sm(:class='driver.gender')
            | {{ driver.gender | capitalize }}
        tr
          td Date of Birth
          td {{ driver.date_of_birth | date }}


</template>

<style lang='stylus' scoped>
  @import '~Styles/global/colors'
  @import '~Styles/global/type'
  @import '~Styles/components/panels/table'

  .gender-icon
    width: 0.5rem
    height: @width
    display: inline-block

    border-radius: 50%

  .gender-icon.male
    background: $background-color-male

  .gender-icon.female
    background: $background-color-female

  .dnr
    width: 100%
    margin: 0
    float: left

    padding: $padding-sm $padding-default

    background: $red

    font-weight: 700
    color: #ffffff

</style>
