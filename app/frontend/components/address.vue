<script>
  export default {
    name: 'Address',
    props: {
      address: {
        required: true,
        type: Object,
      },
    },
  }
</script>

<template lang='pug'>
  address
    span.block {{ address.address_1 || address.street1 }}
    span.block(v-if='address.address_2 || address.street2') {{ address.address_2 || address.street2 }}
    span.block {{ address.city }}, {{ address.state }} {{ address.zip_code }}
</template>
