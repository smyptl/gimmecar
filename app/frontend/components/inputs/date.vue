<script>
  import Moment from 'moment'
  import MomentTimeZone from 'moment-timezone'

  export default {
    props: {
      value: {
        required: true,
      },
      name: {
        type: String,
      },
    },
    data () {
      return {
        current_date: '',
        date_formatted: '',
      }
    },
    mounted () {
      this.parseValue(this.value)
      this.emitInput()
    },
    watch: {
      value (val, oldVal) {
        this.parseValue(val)
      },
    },
    methods: {
      parseValue (val) {
        this.current_date = Moment(val)
        this.formatDate()
      },
      parseDate () {
        var date = Moment(this.date_formatted, 'M/D/YYYY')

        if (date.isValid()) {
          this.current_date.set('date',  date.get('date'))
          this.current_date.set('month', date.get('month'))
          this.current_date.set('year',  date.get('year'))
          this.formatDate()
        } else {
          this.date_formatted = ''
        }

        this.emitInput()
      },
      formatDate () {
        if (this.current_date.isValid()) {
          this.date_formatted = this.current_date.format('M/D/YYYY')
        }
      },
      emitInput () {
        this.$emit('input', this.date_formatted)
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
    v-model='date_formatted'
    @change='parseDate')
</template>
