<script>
  import Moment from 'moment'
  import MomentTimeZone from 'moment-timezone'

  import Range from 'lodash/range'

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
        date_time_formatted: '',
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
      range (start, end) {
        return Range(start, end)
      },
      showClock () {
        this.view_clock = true
      },
      selectDate (value) {
        this.hideCalendar()
      },
      parseValue (val) {
        this.current_date_time = Moment.tz(val, this.time_zone)
        this.formatDateTime()
      },
      parseDateTime () {
        var date = Moment.tz(this.date_time_formatted, "M/D/YYYY @ h:mm A", this.time_zone)

        if (date.isValid()) {
          this.current_date_time = date
        }

        this.formatDateTime()
        this.emitInput()
      },
      formatDateTime () {
        this.date_time_formatted = this.current_date_time.format('M/D/YYYY @ h:mm A')
      },
      emitInput () {
        this.$emit('input', this.current_date_time.format())
      },
    },
  }
</script>

<template lang='pug'>
  input.input-field.date-field(
    type='text'
    placeholder='mm/dd/yyyy @ hh:mm am/pm'
    v-bind:name='name'
    v-model='date_time_formatted'
    @change='parseDateTime')

</template>

<style lang='stylus'>
  @import '~Styles/global/colors'
  @import '~Styles/global/layout'

  .clock
    position: absolute
    width: 100%
    z-index: 2
    margin-top: $input-height + $margin-ex-sm

    background: $white
    border-radius: 0.125rem
    border: 1px solid $border-color-dark

  .clock-hour,
  .clock-minute,
  .clock-period
    float: left
    height: 9rem

    overflow-x: hidden
    overflow-y: auto

  .clock-hour,
  .clock-minute
    border-right: 1px solid $border-color-dark

  .clock-item
    float: left
    width: 95%
    height: 1.5rem
    margin: 0.125rem 2.5%

    border-radius: 0.125rem

    font-size: 0.75rem
    line-height: @height
    text-align: center
    cursor: pointer

    &:hover
      background: $background-color-header

  .clock-item.selected
    background: $blue
    color: $white

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
