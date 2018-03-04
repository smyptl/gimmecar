<script>
  import Chart from 'frappe-charts/dist/frappe-charts.min.esm'

  export default {
    name: 'index',
    data () {
      return {
        chart: null,
        test: null,
      }
    },
    created () {
      this.getData()
    },
    watch: {
      '$route': 'getData',
    },
    methods: {
      setChart () {
        new Chart({
          parent: this.$refs.chart,
          data: this.chart,
          type: 'line',
          height: 200,
          colors: ['yellow'],
        })
      },
      getData () {
        this.$http
          .get(this.$route.path)
          .then(response => {
            this.chart = response.data
            console.log(this.chart)
        })
      },
    },
  }
</script>

<template lang='pug'>
  .panel.panel-base
    #chart(ref='chart')
</template>
