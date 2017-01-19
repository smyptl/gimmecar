<script>
  import Moment from 'moment'
  import MomentTimeZone from 'moment-timezone'
  import EventListener from 'Utils/event_listener'

  import isDate from 'lodash/isDate'
  import Includes from 'lodash/includes'
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
        date_formatted: '',
        hour_formatted: '',
        minute_formatted: '',
        period_formatted: '',
        view_calendar: false,
      }
    },
    mounted () {
      var calendar = this.$el.querySelector('.calendar')
      var input = this.$el.querySelector('.date-field')

      this._closeEvent = EventListener.listen(window, 'click', (e) => {
        if (!calendar.contains(e.target) && !input.contains(e.target)) {
          this.hideCalendar()
        }
      })

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
      showCalendar () {
        this.view_calendar = true
      },
      hideCalendar () {
        this.view_calendar = false
      },
      selectDate (value) {
        this.hideCalendar()
      },
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
        var date_time = Moment(this.hour_formatted + ':' + this.minute_formatted + ' ' + this.period_formatted, ["h:mm A"])

        this.current_date_time.set('hour', date_time.hour())
        this.current_date_time.set('minute', date_time.minute())

        this.emitInput()
      },
      formatDate () {
        this.date_formatted = this.current_date_time.format("M/D/YYYY")
      },
      formatTime () {
        this.hour_formatted   = this.current_date_time.format('h')
        this.minute_formatted = this.current_date_time.format('m')
        this.period_formatted = this.current_date_time.format('A')
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
      input.input-field.date-field(
        type='text'
        placeholder='mm/dd/yyyy'
        v-bind:name='name'
        v-model='date_formatted'
        @change='parseDate')

    .input-container.one-half.fixed
      .input-block.one-third.fixed
        select.input-field(v-bind:name='name' v-model='hour_formatted' @change='parseTime')
          option(value='' disabled) --
          option(v-for='n in range(1, 13)' value=n) {{ n }}
      .input-block.one-third.fixed
        select.input-field(v-bind:name='name' v-model='minute_formatted' @change='parseTime')
          option(value='' disabled) --
          option(v-for='n in range(0, 60)' value=n) {{ n }}

      .input-block.one-third.fixed
        select.input-field(v-bind:name='name' v-model='period_formatted' @change='parseTime')
          option(value='' disabled) --
          option(value='AM') AM
          option(value='PM') PM

    <!--.input-block.whole-->
      .calendar(v-show='view_calendar')
        span.calendar-header
          a.left &#8592;
          | January 2017
          a.right &#8594;
        .calendar-content
          .whole.left
            span.calendar-sub-header S
            span.calendar-sub-header M
            span.calendar-sub-header T
            span.calendar-sub-header W
            span.calendar-sub-header T
            span.calendar-sub-header F
            span.calendar-sub-header S
          span.calendar-row
            a.calendar-day.disabled(@click='selectDate(value)') 1
            a.calendar-day.selected(@click='selectDate(value)') 2
            a.calendar-day(@click='selectDate(value)') 3
            a.calendar-day(@click='selectDate(value)') 4
            a.calendar-day(@click='selectDate(value)') 5
            a.calendar-day(@click='selectDate(value)') 6
            a.calendar-day(@click='selectDate(value)') 7
          span.calendar-row
            a.calendar-day(@click='selectDate(value)') 8
            a.calendar-day(@click='selectDate(value)') 9
            a.calendar-day(@click='selectDate(value)') 10
            a.calendar-day(@click='selectDate(value)') 11
            a.calendar-day(@click='selectDate(value)') 12
            a.calendar-day(@click='selectDate(value)') 13
            a.calendar-day(@click='selectDate(value)') 14
          span.calendar-row
            a.calendar-day(@click='selectDate(value)') 15
            a.calendar-day(@click='selectDate(value)') 16
            a.calendar-day(@click='selectDate(value)') 17
            a.calendar-day(@click='selectDate(value)') 18
            a.calendar-day(@click='selectDate(value)') 19
            a.calendar-day(@click='selectDate(value)') 20
            a.calendar-day(@click='selectDate(value)') 21
          span.calendar-row
            a.calendar-day(@click='selectDate(value)') 22
            a.calendar-day(@click='selectDate(value)') 23
            a.calendar-day(@click='selectDate(value)') 24
            a.calendar-day(@click='selectDate(value)') 25
            a.calendar-day(@click='selectDate(value)') 26
            a.calendar-day(@click='selectDate(value)') 27
            a.calendar-day(@click='selectDate(value)') 28
          span.calendar-row
            a.calendar-day(@click='selectDate(value)') 29
            a.calendar-day(@click='selectDate(value)') 30
            a.calendar-day(@click='selectDate(value)') 31
            a.calendar-day.disabled
            a.calendar-day.disabled
            a.calendar-day.disabled
            a.calendar-day.disabled
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

    background: #ffffff
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
    color: #999999

  .calendar-day
    height: 1.75rem

    border-right: 1px solid $border-color-panel
    background: #ffffff

    line-height: @height
    font-size: 0.8125rem
    font-weight: 700
    cursor: pointer

    &:hover
      background: $background-color-panel
      color: $blue

  .calendar-day.disabled
    cursor: not-allowed
    color: #999999

    &:hover
      background: #ffffff

  .calendar-day.selected
    background: $blue
    color: #ffffff

</style>
