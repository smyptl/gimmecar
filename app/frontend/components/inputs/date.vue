<script>

  export default {
    props: {
      value: {
        required: true,
      },
      name: {
        type: String,
        required: true,
      },
    },
    mounted () {
      this.updateValue(this.value)
    },
    watch: {
      value (val, oldVal) {
        this.updateValue(val)
      },
    },
    methods: {
      updateValue (val) {
        if (val) {
          let date = null;

          if (typeof val.getMonth === 'function') {
            date = val;
          } else {
            date = new Date(val);
          }

          if (!isNaN(date.getTime())) {
            var yyyy = date.getFullYear().toString();
            var mm = (date.getMonth() + 1).toString(); // getMonth() is zero-based
            var dd = date.getDate().toString();
            this.$emit('input', mm + '/' + dd + '/' + yyyy);
          }
        } else {
          this.$emit('input', '');
        }
      },
    },
  }
</script>

<template lang='pug'>
  input.input-field(
    type='text'
    placeholder='mm/dd/yyyy'
    v-bind:name='name'
    v-bind:value='value'
    v-on:change="updateValue($event.target.value)")
</template>
