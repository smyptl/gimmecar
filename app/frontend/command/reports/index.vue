<script>
  import Highcharts from 'highcharts'

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
    mounted () {
      this.setChart()
    },
    watch: {
      '$route': 'getData',
    },
    methods: {
      setChart () {
        Highcharts.chart(this.$refs.chart, {
          chart: {
            type: 'line',
          },
          title: {
            text: '',
          },
          xAxis: {
            categories:  this.chart.labels,
          },
          yAxis: {
            title: 'Test',
          },
          series: this.chart.datasets
        })
      },
      getData () {
        this.$http
          .get(this.$route.path)
          .then(response => {
            this.chart = response.data
        })
      },
    },
  }
</script>

<template lang='pug'>
  .panel.panel-base
    #chart(ref='chart')
</template>
