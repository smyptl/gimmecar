<script>
  import Moment from 'moment'

  import Times from 'lodash/times'

  export default {
    name: 'calendar',
    computed: {
      date_range () {
        return Times(62, n => {
          return Moment().add(n, 'days')
        })
      },
      vehicles () {
        return []
      },
    },
  }
</script>

<template lang='pug'>
  #calendar
    #calendar-sidebar
      .calendar-header
        .calendar-sidebar-name

      .calendar-rentals
        .calendar-vehicle
          .calendar-sidebar-name Compact

      .calendar-vehicles
        .calendar-vehicle
          .calendar-sidebar-name Toyota Corolla
        .calendar-vehicle
          .calendar-sidebar-name Toyota Corolla


    #calendar-content
      .calendar-scroll
        .calendar-header
          .calendar-header-date(v-for='date in date_range')
            span.date {{ date.format('D') }}

        .calendar-rentals
          .calendar-rental
            .calendar-items
              .calendar-item.reserved(style='left: 10rem; width: 2rem')
              .calendar-item.reserved(style='left: 18rem; width: 6rem')

        .calendar-vehicles
          .calendar-vehicle
            .calendar-items
              .calendar-item.current(style='left: 0rem; width: 10rem')
              .calendar-item.reserved(style='left: 14rem; width: 4rem') #cak123
              .calendar-item.reserved(style='left: 24rem; width: 4rem')
              .calendar-item.reserved(style='left: 30rem; width: 4rem')

          .calendar-vehicle
            .calendar-items
              .calendar-item.current(style='left: 0rem; width: 4rem')
              .calendar-item.reserved(style='left: 20rem; width: 10rem')
              .calendar-item.reserved(style='left: 14.25rem; width: 4rem')

</template>

<style lang='stylus' scoped>
  @import '~Styles/global/colors'
  @import '~Styles/global/layout'

  $vehicle-name-width = 8rem
  $unit-height = 2rem
  $unit-width = 2rem
  $calendar-min-width = ($unit-width*62)+$vehicle-name-width

  #calendar
    float: left
    width: 100%

    display: flex
    flex-direction: row

    background: $background-color-panel
    border-radius: 0.125rem
    border: 1px solid $border-color-panel

  #calendar-sidebar
    width: auto

  #calendar-content
    flex: 1
    overflow-y: auto

  .calendar-header
    padding-bottom: $padding-ex-sm
    border-bottom: 1px solid $border-color-panel

  .calendar-scroll
    width: 62*$unit-width
    min-width: 100%

  .calendar-header-date
    width: $unit-width
    height: $unit-height
    float: left
    text-align: left

    .date
      width: 100%
      display: inline-block
      float: left
      padding-top: $unit-height - 1.25rem

      font-size: 0.625rem
      font-weight: 700
      color: $text-color-light
      line-height: 1.25rem

  .calendar-vehicle
    height: 2rem

  .calendar-sidebar-name
    width: auto
    height: $unit-height
    padding-right: $padding-sm
    padding-left: $padding-sm

    font-size: 0.75rem
    line-height: $unit-height

  .calendar-items
    height: 2rem
    border-bottom: 1px solid $border-color-light

  .calendar-item
    position: absolute
    top: 0
    margin-top: $margin-ex-sm
    margin-bottom: $margin-ex-sm
    height: 2rem - 0.125rem - $margin-ex-sm*2
    width: auto

    border: 1px solid #efefef
    border-radius: 0.125rem

    text-align: center
    font-size: 0.625rem
    font-weight: 600
    line-height: @height - 0.125rem

  .calendar-item.current
    border-color: #98d9c2
    background: lighten(@border-color, 80%)
    border-left: 0
    border-top-left-radius: 0
    border-bottom-left-radius: 0

  .calendar-item.reserved
    border-color: #998fcc
    background: lighten(@border-color, 80%)

</style>
