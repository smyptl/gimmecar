export default {
  data() {
    return {
      page_loading: true,
    },
  },
  methods: {
    pageLoadStart() {
    },
    pageLoadFinish() {
      this.page_loading = false
    },
  }
}
