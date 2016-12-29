<script>

  export default {
    bind(el, binding, vnode) {
      if (binding.value && binding.value[binding.arg]) {
        el.className += ' input-field-error'
      } else {
        el.className.replace(/\binput-field-error\b/,'')
      }
    },
    update(el, binding, vnode) {
      if (binding.value && binding.value[binding.arg]) {
        el.className += ' input-field-error'
      } else {
        el.className.replace(/\binput-field-error\b/,'')
      }
    },
  }
</script>
