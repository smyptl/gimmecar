<script>

  var addRemoveClass = (el, binding, vnode) => {
    if (binding.value && binding.value[binding.arg]) {
      if (!el.className.includes('input-field-error')) {
        el.className += ' input-field-error'
      }
    } else {
      el.className = el.className.replace(/input-field-error/g, '')
    }
  }

  export default {
    bind(el, binding, vnode) {
      addRemoveClass(el, binding, vnode)
    },
    update(el, binding, vnode) {
      addRemoveClass(el, binding, vnode)
    }
  }
</script>
