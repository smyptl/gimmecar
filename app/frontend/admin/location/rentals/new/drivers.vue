<script>
  import Shake from 'Utils/transitions/shake'

  import Driver           from 'Admin/location/components/driver'
  import DriverAdditional from 'Admin/location/components/driver_additional'

  export default {
    name: 'Drivers',
    props: {
      form: {
        type: Object,
        required: true,
      },
    },
    components: {
      Driver,
      DriverAdditional,
    },
  }
</script>

<template lang='pug'>
  div
    driver.left(:form='form')

    .mt-sm.left
      template(v-if='form.add_additional_driver')
        a.link-danger(@click.prevent='form.add_additional_driver = false')
          h3.panel-form-header Remove Additional Driver
        driver-additional.left(:form='form')

      template(v-else)
        a.mt-sm(@click.prevent='form.add_additional_driver = true')
          h3.panel-form-header Add Additional Driver
</template>
