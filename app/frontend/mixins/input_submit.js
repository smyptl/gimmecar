import InputSubmit from 'Components/inputs/submit'

export default {
  data() {
    return {
      input_submit_loading: false,
    }
  },
  components: {
    InputSubmit,
  },
  methods: {
    inputSubmitStart() {
      return this.input_submit_loading = true
    },
    inputSubmitFinish() {
      return this.input_submit_loading = false
    }
  }
}
