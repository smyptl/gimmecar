<script>
  import Includes from 'lodash/includes'

  var addRemoveClass = (el, binding, vnode) => {
    if (binding.value) {
      if (!Includes(el.className, 'input-field-error')) {
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
    },
  }
</script>
