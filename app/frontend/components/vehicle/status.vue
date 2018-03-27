<script>
  export default {
    name: 'Vehicle-Status',
    props: {
      status: {
        required: true,
        type: String,
      },
    },
  }
</script>

<template lang='pug'>
  div
    svg#service(v-if='status == "service"' xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round")
      polyline(points="22 12 18 12 15 21 9 3 6 12 2 12")
    svg#rented(v-if='status == "rented"' xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round")
      polyline(points="3 11 22 2 13 21 11 13 3 11")
    svg#clean(v-if='status == "clean"' xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round")
      path(d="M22 11.07V12a10 10 0 1 1-5.93-9.14")
      polyline(points="23 3 12 14 9 11")
    svg#dirty(v-if='status == "dirty"' xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round")
      circle(cx="12" cy="12" r="10")
      line(x1="12" y1="8" x2="12" y2="12")
      line(x1="12" y1="16" x2="12" y2="16")
</template>

<style lang='stylus' scoped>
  @import '~Styles/global/colors'

  svg
    float: left
    fill: none

    height: 1rem
    width: 1rem
    color: $blue-dark

  svg#service
    color: $text-color-yellow

  svg#clean
    color: $text-color-green

  svg#dirty
    color: $text-color-red

</style>
