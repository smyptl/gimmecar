<script>
  import Moment from 'moment'
  import MomentTimeZone from 'moment-timezone'
  import EventListener from 'Utils/event_listener'

  import isDate from 'lodash/isDate'
  import Includes from 'lodash/includes'

  const MONTH_NAMES = [
    'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December',
  ]

  const DATE_REGEX = /^((((0[13578])|([13578])|(1[02]))[\/](([1-9])|([0-2][0-9])|(3[01])))|(((0[469])|([469])|(11))[\/](([1-9])|([0-2][0-9])|(30)))|((2|02)[\/](([1-9])|([0-2][0-9]))))[\/]\d{4}$|^\d{4}$/

  export default {
    props: {
      value: {
        require: true,
      },
      name: {
        type: String,
      },
      time_zone: {
        type: String,
        default () {
          return Moment.tz.guess()
        }
      },
    },
    data () {
      return {
        current_date_time: '',
        date_formatted: '',
        time_formatted: '',
        view_calendar: false,
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
        this.current_date_time = Moment.tz(val, this.time_zone)
        this.formatDate()
        this.formatTime()
      },
      parseDate () {
        if (this.date_formatted.match(DATE_REGEX)) {
          var date = Moment.tz(this.date_formatted, "MM/DD/YYYY", this.time_zone)
        } else {
          var date = Moment.tz(this.date_formatted, "MM/DD/YY", this.time_zone)
        }

        if (date._isValid) {
          this.current_date_time.set('date',  date.get('date'))
          this.current_date_time.set('month', date.get('month'))
          this.current_date_time.set('year',  date.get('year'))
        }

        this.formatDate()
        this.emitInput()
      },
      parseTime () {
        var time = Moment.tz(this.time_formatted, "HHmm", this.time_zone)
        this.current_date_time.set('hour',   time.get('hour'))
        this.current_date_time.set('minute', time.get('minute'))
        this.emitInput()
      },
      formatDate () {
        this.date_formatted = this.current_date_time.format("M/D/YYYY")
      },
      formatTime () {
        var minutes = this.current_date_time.format('mm')

        if (Includes(['00', '30'], minutes)) {
          this.time_formatted = this.current_date_time.format('HHmm')
        }
      },
      emitInput () {
        this.$emit('input', this.current_date_time.format())
      },
    },
  }
</script>

<template lang='pug'>
  .whole.left
    .input-block.one-half.fixed
      input.input-field.input-lg(
        type='text'
        placeholder='mm/dd/yyyy'
        v-bind:name='name'
        v-model='date_formatted'
        @change='parseDate')

    .input-block.one-half.fixed
      select.input-field.input-lg(placeholder='--:-- AM/PM' v-bind:name='name' v-model='time_formatted' @change='parseTime')
        option(value='' disabled) --:-- AM/PM
        option(value='0000') 12:00 AM
        option(value='0030') 12:30 AM
        option(value='0100') 1:00 AM
        option(value='0130') 1:30 AM
        option(value='0200') 2:00 AM
        option(value='0230') 2:30 AM
        option(value='0300') 3:00 AM
        option(value='0330') 3:30 AM
        option(value='0400') 4:00 AM
        option(value='0430') 4:30 AM
        option(value='0500') 5:00 AM
        option(value='0530') 5:30 AM
        option(value='0600') 6:00 AM
        option(value='0630') 6:30 AM
        option(value='0700') 7:00 AM
        option(value='0730') 7:30 AM
        option(value='0800') 8:00 AM
        option(value='0830') 8:30 AM
        option(value='0800') 8:00 AM
        option(value='0830') 8:30 AM
        option(value='0900') 9:00 AM
        option(value='0930') 9:30 AM
        option(value='1000') 10:00 AM
        option(value='1030') 10:30 AM
        option(value='1100') 11:00 AM
        option(value='1130') 11:30 AM
        option(value='1200') 12:00 PM
        option(value='1230') 12:30 PM
        option(value='1300') 1:00 PM
        option(value='1330') 1:30 PM
        option(value='1400') 2:00 PM
        option(value='1430') 2:30 PM
        option(value='1500') 3:00 PM
        option(value='1530') 3:30 PM
        option(value='1600') 4:00 PM
        option(value='1630') 4:30 PM
        option(value='1700') 5:00 PM
        option(value='1730') 5:30 PM
        option(value='1800') 6:00 PM
        option(value='1830') 6:30 PM
        option(value='1900') 7:00 PM
        option(value='1930') 7:30 PM
        option(value='2000') 8:00 PM
        option(value='2030') 8:30 PM
        option(value='2100') 9:00 PM
        option(value='2130') 9:30 PM
        option(value='2200') 10:00 PM
        option(value='2230') 10:30 PM
        option(value='2300') 11:00 PM
        option(value='2330') 11:30 PM

</template>

<style lang='stylus'>
  @import '~Styles/global/colors'
  @import '~Styles/global/layout'

  .calendar
    position: absolute
    z-index: 2
    width: 100%
    max-width: 20rem
    margin-top: $margin-ex-sm

    background: $white
    border: 1px solid #dddddd
    border-radius: 2px
    box-shadow: 0 1px 0.125rem 0 $border-color-dark

  .calendar-header
    width: 100%
    float: left
    height: 1.75rem

    line-height: @height
    font-size: 0.875rem
    font-weight: 700
    text-align: center

  .calendar-content
    width: 100%
    float: left

  .calendar-row
    float: left
    width: 100%
    border-top: 1px solid #efefef

    .calendar-day:nth-of-type(7)
      border-right: 0

  .calendar-day,
  .calendar-sub-header
    float: left
    width: (1/7)*100%
    text-align: center

  .calendar-sub-header
    height: 1.25rem

    line-height: @height
    font-size: 0.6875rem
    font-weight: 600
    color: $text-color-light

  .calendar-day
    height: 1.75rem

    border-right: 1px solid $border-color-panel
    background: $white

    line-height: @height
    font-size: 0.8125rem
    font-weight: 700
    cursor: pointer

    &:hover
      background: $background-color-panel
      color: $blue

  .calendar-day.disabled
    cursor: not-allowed
    color: $text-color-light

    &:hover
      background: $white

  .calendar-day.selected
    background: $blue
    color: $white

</style>
