<script>
  import Moment from 'moment'

  export default {
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
        current_date: '',
        date_formatted: '',
      }
    },
    mounted() {
      this.parseValue(this.value)
      this.emitInput()
    },
    watch: {
      value(val, oldVal) {
        this.parseValue(val)
      },
    },
    methods: {
      parseValue(val) {
        this.current_date = Moment(val)
        this.formatDate()
      },
      parseDate() {
        var date = Moment(this.date_formatted, 'M/D/YYYY')

        if (date.isValid()) {
          this.current_date = date
        } else {
          this.current_date = null
        }

        this.formatDate()
        this.emitInput()
      },
      formatDate() {
        if (this.current_date && this.current_date.isValid()) {
          this.date_formatted = this.current_date.format('M/D/YYYY')
        } else {
          this.date_formatted = null
        }
      },
      emitInput() {
        this.$emit('input', this.date_formatted)
      },
    },
  }
</script>

<template lang='pug'>
  input.input-field(
    type='text'
    placeholder='mm/dd/yyyy'
    :name='name'
    v-model='date_formatted'
    @change='parseDate')
</template>
