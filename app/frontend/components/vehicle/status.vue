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
  svg(:class='status' xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round")
    template(v-if='status == "clean"')
      path(d="M22 11.07V12a10 10 0 1 1-5.93-9.14")
      polyline(points="23 3 12 14 9 11")
    template(v-else-if='status == "service"')
      polyline(points="22 12 18 12 15 21 9 3 6 12 2 12")
    template(v-else-if='status == "rented"')
      polyline(points="3 11 22 2 13 21 11 13 3 11")
    template(v-else-if='status == "dirty"')
      circle(cx="12" cy="12" r="10")
      line(x1="12" y1="8" x2="12" y2="12")
      line(x1="12" y1="16" x2="12" y2="16")
    template(v-else-if='status == "decommissioned"')
      polyline(points='21 8 21 21 3 21 3 8')
      rect(x='1' y='3' width='22' height='5')
      line(x1='10' y1='12' x2='14' y2='12')
</template>

<style lang='stylus' scoped>
  @import '~Styles/global/colors'

  svg
    float: left
    fill: none

    height: 1rem
    width: 1rem

  svg.rented
    color: $blue-dark

  svg.service
    color: $text-color-yellow

  svg.clean
    color: $text-color-green

  svg.dirty
    color: $text-color-red

  svg.decommissioned
    color: $brown

</style>
