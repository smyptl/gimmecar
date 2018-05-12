<script>
  export default {
    name: 'PhoneNumber',
    props: {
      phone: {
        required: true,
        type: Object,
      },
    },
  }
</script>

<template lang='pug'>
  a(:href="'tel:' + phone.number")
    span.block {{ phone.number }}
    i.block(v-if='phone.extension') Ext: {{ phone.extension }}
</template>
