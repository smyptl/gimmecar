<script>
  import FormatCurrency from 'Filters/currency';

  export default {
    name: 'InputCurrency',
    props: {
      value: {
        required: true,
      },
      name: {
        type: String,
      },
    },
    data() {
      return {
        formatted: '',
      }
    },
    mounted() {
      this.formatCurrency(this.value)
    },
    watch: {
      value(val, oldVal) {
        this.formatCurrency(val)
      },
    },
    methods: {
      parseCurrency() {
        let value = this.formatted.replace('$','');
        value = parseFloat(value) * 100;
        value = parseInt(value);

        this.$emit('input', value);
        this.formatCurrency(value);
      },
      formatCurrency(value) {
        this.formatted = FormatCurrency(value);
      },
    },
  }
</script>

<template lang='pug'>
  input.input-field(
    type='text'
    placeholder='$_,___.__'
    :name='name'
    v-model='formatted'
    @change='parseCurrency()')
</template>
