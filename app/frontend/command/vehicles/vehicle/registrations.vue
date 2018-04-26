<script>
  import FDate from 'Filters/date';
  import IconDownload from 'Components/icons/download'

  export default {
    name: 'Registrations',
    props: {
      registrations: {
        type: Object,
        required: true,
      },
    },
    components: {
      IconDownload,
    },
    filters: {
      FDate,
    },
  }
</script>

<template lang='pug'>
  .panel.panel-base
    .gimmecar-app-vertical-scroll
      table.panel-table
        thead
          tr
            th Effective Date
            th Expiration Date
            th
        tbody
          tr(v-for='registration in registrations.data'
             :key='registration.id')

            td {{ registration.date_effective | f-date }}
            td {{ registration.date_expiration | f-date }}
            td
              a.right.btn.btn-icon.btn-sm(:href='registration.url')
                icon-download
</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/table'

  .icon-download
    height: 1.25rem

    svg
      height: 1.25rem
</style>
