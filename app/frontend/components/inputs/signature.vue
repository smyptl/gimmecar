<script>
  import SignaturePad from 'signature_pad'

  import EventListener from 'Utils/event_listener'

  export default {
    props: {
      value: {
        required: true,
      },
    },
    data () {
      return {
        signature_pad: null,
        event_listener: null,
      }
    },
    mounted () {
      this.resizeCanvas()

      var self = this

      this.signature_pad = new SignaturePad(this.$el, {
        onEnd: function () {
          self.updateValue();
        }
      })

      this.event_listener = EventListener.listen(window, 'resize', (e) => {
        this.resizeCanvas()
      })
    },
    destroyed () {
      this.event_listener.remove()
    },
    methods: {
      resizeCanvas () {
        this.$el.width = this.$el.parentElement.offsetWidth - 7
        this.$el.height = 160
      },
      updateValue () {
        this.$emit('input', this.signature_pad.toDataURL())
      },
    },
  }
</script>

<template lang='pug'>
  canvas.left
</template>

<style lang='stylus' scoped>
  @import '~Styles/global/colors'
  @import '~Styles/global/layout'

  canvas
    margin: $margin-sm auto 0

    border: 0.125rem dashed $border-color-input
    border-radius: 0.25rem
    background-color: rgba(255, 255, 255, 0.5)

</style>
