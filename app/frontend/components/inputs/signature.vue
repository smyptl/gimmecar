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

      this.signature_pad = new SignaturePad(this.canvas, {
        onEnd: function () {
          self.updateValue();
        }
      })

      this.event_listener = EventListener.listen(window, 'resize', (e) => {
        self.resizeCanvas()
        self.clearSignature()
      })

      this.drawSignature()
    },
    watch: {
      value (val, oldVal) {
        this.drawSignature()
      },
    },
    destroyed () {
      this.event_listener.remove()
    },
    computed: {
      canvas () {
        return this.$el.getElementsByTagName('canvas')[0]
      },
    },
    methods: {
      resizeCanvas () {
        var ratio =  Math.max(window.devicePixelRatio || 1, 1)
        this.canvas.width = this.canvas.offsetWidth * ratio
        this.canvas.height = this.canvas.offsetHeight * ratio
        this.canvas.getContext('2d').scale(ratio, ratio)
      },
      updateValue () {
        this.$emit('input', this.signature_pad.toDataURL())
      },
      clearSignature () {
        this.signature_pad.clear()
        this.$emit('input', '')
      },
      drawSignature () {
        this.signature_pad.fromDataURL(this.value)
      },
    },
  }
</script>

<template lang='pug'>
  .whole.left
    canvas.left
    button.btn.btn-sm.btn-danger-muted(@click.prevent='clearSignature') Clear
</template>

<style lang='stylus' scoped>
  @import '~Styles/global/colors'
  @import '~Styles/global/layout'

  canvas
    width: 100%
    height: 12rem
    margin: $margin-sm 0 $input-padding-y

    border-width: 0.125rem
    border-style: dashed
    border-color: $border-color-input
    border-radius: 0.125rem
    background-color: rgba(255, 255, 255, 0.5)

  button
    position: absolute
    bottom: $margin-sm
    right: $margin-sm

</style>
