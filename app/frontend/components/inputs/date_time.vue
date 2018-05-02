<script>
  import EventListener from 'Utils/event_listener.js';

  import Moment from 'moment'
  import MomentTimeZone from 'moment-timezone'

  import Range from 'lodash/range'
  import Times from 'lodash/times'

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
        default() {
          return Moment.tz.guess()
        }
      },
      disabled: {
        type: Boolean,
        default: false,
      },
      classes: {
        type: Array,
        default() {
          return []
        },
      },
    },
    data() {
      return {
        current_date_time: '',
        date_time_formatted: '',
        calendar: false,
        calendar_date_time: '',
      }
    },
    mounted() {
      this.parseValue(this.value)

      let month_year = this.current_date_time.clone()
      month_year.date(1)

      this.calendar_date_time = month_year

      const el = this.$el;

      this._closeEvent = EventListener.listen(window, 'click', (e) => {
        if (!el.contains(e.target)) {
          this.closeCalendar()
        }
      });
    },
    beforeDestroy() {
      if (this._closeEvent) {
        this._closeEvent.remove();
      }
    },
    watch: {
      value(val, oldVal) {
        this.parseValue(val)
      },
    },
    computed: {
      current_date() {
        return Moment(new Date(this.current_date_time.year(), this.current_date_time.month(), this.current_date_time.date()))
      },
      calendar_month_name() {
        return MONTH_NAMES[this.calendar_date_time.month()]
      },
      calendar_year() {
        return this.calendar_date_time.year()
      },
      calendar_dates() {
        return Times(this.calendar_days_in_month, (day) => {
          return Moment(new Date(this.calendar_date_time.year(), this.calendar_date_time.month(), day + 1))
        })
      },
      calendar_days_in_month() {
        return new Date(this.calendar_date_time.year(), this.calendar_date_time.month() + 1, 0).getDate()
      },
      calendar_beginning_blank_dates() {
        if (this.calendar_date_time.day() == 0) {
          return 0
        }

        return this.calendar_date_time.day()
      },
      calendar_ending_blank_dates() {
        let days_remaining = (this.calendar_beginning_blank_dates + this.calendar_dates.length) % 7

        if (days_remaining != 0) {
          return 7 - days_remaining
        }

        return 0
      },
      calendar_clock_hour() {
        return this.current_date_time.format('h')
      },
      calendar_clock_minute() {
        return this.current_date_time.format('mm')
      },
      calendar_clock_period() {
        return this.current_date_time.format('A')
      },
    },
    methods: {
      calendar_one_month_back() {
        return this.calendar_date_time = this.calendar_date_time.subtract(1, 'months').clone()
      },
      calendar_one_month_forward() {
        return this.calendar_date_time = this.calendar_date_time.add(1, 'months').clone()
      },
      calendar_selected_date (d) {
        return d.format() == this.current_date.format()
      },
      calendarAddHour() {
        if (this.current_date_time.hour() == 23) {
          this.current_date_time.hour(0)
        } else {
          this.current_date_time.add(1, 'hour')
        }

        this.formatDateTime()
      },
      calendarSubtractHour() {
        if (this.current_date_time.hour() == 0) {
          this.current_date_time.hour(23)
        } else {
          this.current_date_time.subtract(1, 'hour')
        }

        this.formatDateTime()
      },
      calendarAddMinute() {
        if (this.current_date_time.minute() == 59) {
          this.current_date_time.minute(0)
        } else {
          this.current_date_time.add(1, 'minute')
        }

        this.formatDateTime()
      },
      calendarSubtractMinute() {
        if (this.current_date_time.minute() == 0) {
          this.current_date_time.minute(59)
        } else {
          this.current_date_time.subtract(1, 'minute')
        }

        this.formatDateTime()
      },
      selectDate(val) {
        this.current_date_time.year(val.year())
        this.current_date_time.month(val.month())
        this.current_date_time.date(val.date())

        this.formatDateTime()
      },
      parseValue(val) {
        this.current_date_time = Moment.tz(val, this.time_zone)
        this.formatDateTime()
      },
      formatDateTime() {
        this.date_time_formatted = this.current_date_time.format('M/D/YYYY @ h:mm A')
        this.emitInput()
      },
      emitInput() {
        this.$emit('input', this.current_date_time.format())
      },
      toggleCalendar() {
        if (this.disabled) {
          return
        }

        this.calendar = (false == this.calendar)
      },
      closeCalendar() {
        this.calendar = false
      },
      showCalendar() {
        if (this.disabled) {
          return
        }

        this.calendar = true
      },
    },
  }
</script>

<template lang='pug'>
  .whole.left(
    @focus='showCalendar'
    @blur='closeCalendar'
  )
    input.input-field.date-field(
      type='text'
      :class='{ focus: calendar, disabled: disabled }'
      @click='toggleCalendar'
      :value='date_time_formatted'
      readonly
    )

    .calendar(v-if='calendar')
      .calendar-header
        a.left(@click.prevent='calendar_one_month_back()')
          svg(xlmns='http://www.w3.org/2000/svg' viewBox='-175 -175 1000 1000' fill='currentColor' preserveAspectRatio='xMinYMin')
            path(d='M308 349l346-346-154-154-500 500 500 500 154-154z')

        span {{ calendar_month_name }} {{ calendar_year }}
        a.right(@click.prevent='calendar_one_month_forward()')
          svg(xlmns='http://www.w3.org/2000/svg' viewBox='-250 -175 1000 1000' fill='currentColor' preserveAspectRatio='xMinYMin')
            path(d='M154 849l500-500-500-500-154 154 346 346-346 346z')

      .calendar-content
        .calendar-row
          .calendar-sub-header Su
          .calendar-sub-header Mo
          .calendar-sub-header Tu
          .calendar-sub-header We
          .calendar-sub-header Th
          .calendar-sub-header Fr
          .calendar-sub-header Sa
        .calendar-row
          .calendar-day(v-for='date in calendar_beginning_blank_dates')
          .calendar-day(v-for='date in calendar_dates' @click='selectDate(date)' :class='[{ selected: calendar_selected_date(date) }]') {{ date.date() }}
          .calendar-day(v-for='date in calendar_ending_blank_dates')

      .clock
        .clock-hour
          .clock-plus
            a(@click.prevent='calendarAddHour()')
              svg(xlmns='http://www.w3.org/2000/svg' viewBox='-15 15 1000 1000' fill='currentColor' preserveAspectRatio='xMinYMin')
               path(d='M911 388.5l0 223l-335 0l0 335l-223 0l0 -335l-335 0l0 -223l335 0l0 -335l223 0l0 335l335 0z')
          .clock-item.selected {{ calendar_clock_hour }}
          .clock-minus
            a(@click.prevent='calendarSubtractHour()')
              svg(xlmns='http://www.w3.org/2000/svg' viewBox='-15 15 1000 1000' fill='currentColor' preserveAspectRatio='xMinYMin')
               path(d='M18 611.5l0 -223l893 0l0 223l-893 0z')
        .clock-colon
          .clock-plus
          .clock-item :
          .clock-minus
        .clock-minute
          .clock-plus
            a(@click.prevent='calendarAddMinute()')
              svg(xlmns='http://www.w3.org/2000/svg' viewBox='-15 15 1000 1000' fill='currentColor' preserveAspectRatio='xMinYMin')
               path(d='M911 388.5l0 223l-335 0l0 335l-223 0l0 -335l-335 0l0 -223l335 0l0 -335l223 0l0 335l335 0z')
          .clock-item.selected {{ calendar_clock_minute }}
          .clock-minus
            a(@click.prevent='calendarSubtractMinute()')
              svg(xlmns='http://www.w3.org/2000/svg' viewBox='-15 15 1000 1000' fill='currentColor' preserveAspectRatio='xMinYMin')
               path(d='M18 611.5l0 -223l893 0l0 223l-893 0z')
        .clock-colon
        .clock-period
          .clock-plus
          .clock-item.selected {{ calendar_clock_period }}
          .clock-minus

</template>

<style lang='stylus' scoped>
  @import '~Styles/global/colors'
  @import '~Styles/global/layout'
  @import '~Styles/global/type'

  .clock
    float: left
    width: 100%

    padding: $padding-sm  20%

    background: $white
    border-top: 1px solid $border-color-panel

  .clock-hour,
  .clock-colon,
  .clock-minute,
  .clock-period
    float: left
    width: 30%

  .clock-colon
    width: 10%

  .clock-plus,
  .clock-item,
  .clock-minus
    width: 100%
    float: left
    text-align: center

  .clock-plus,
  .clock-minus
    height: 1rem

    a
      svg
        height: 0.75rem
        width: 0.75rem

  .clock-item
    height: 2rem + 2*$padding-ex-sm

    line-height: @height
    font-size: 1.25rem
    font-family: $font-mono
    cursor: pointer
    color: $gray

    input
      height: 2rem
      margin: 0
      float: left

      text-align: center
      font-size: 1.25rem

  .clock-item.selected
    color: $black

  .calendar
    position: absolute
    z-index: 2
    width: 100%
    top: 100%
    max-width: 22rem

    background: $white
    border: 1px solid #dddddd
    border-radius: 2px
    box-shadow: 0 1px 0.125rem 0 $border-color-dark

    font-family: $font-mono

  .calendar-header
    width: 100%
    float: left
    height: 2.5rem

    line-height: @height
    font-size: 1rem
    text-align: center

    a
      height: 1rem
      line-height: @height
      margin: 0.75rem @margin-sm

      svg
        width: 1rem
        height: 1rem

  .calendar-content
    width: 100%
    float: left

  .calendar-row
    float: left
    width: 100%
    border-top: 1px solid #efefef

    .calendar-day:nth-child(7n)
      border-right: 0

    .calendar-day:nth-child(1n+8)
      border-top: 1px solid $border-color-panel

  .calendar-day,
  .calendar-sub-header
    float: left
    width: (1/7)*100%
    text-align: center

  .calendar-sub-header
    height: 1.25rem

    line-height: @height
    font-size: 0.6875rem
    color: $text-color-light

  .calendar-day
    height: 1.75rem

    border-right: 1px solid $border-color-panel
    background: $white

    line-height: @height
    font-size: 0.8125rem
    cursor: pointer

    &:hover
      background: $background-color-panel
      color: $purple

  .calendar-day.disabled
    cursor: not-allowed
    color: $text-color-light

    &:hover
      background: $white

  .calendar-day.selected
    background: $border-color-panel

</style>
