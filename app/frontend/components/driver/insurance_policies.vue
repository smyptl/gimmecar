<script>
  import TDate from 'Filters/date'

  export default {
    name: 'Driver-Insurance-Policies',
    props: {
      insurance_policies: {
        required: true,
        type: Object,
      },
    },
    filters: {
      date: TDate,
    },
  }
</script>

<template lang='pug'>
  .panel.panel-base
    .gimmecar-app-vertical-scroll
      table.panel-table
        thead
          tr
            th Company
            th Policy #
            th Effective Date
            th Expiration Date
        tbody
          tr(
            v-for='policy in insurance_policies.data'
            :key='policy.id'
          )

            td {{ policy.company_name }}
            td {{ policy.policy_number }}
            td {{ policy.effective_date | date }}
            td {{ policy.expiration_date | date }}
</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/table'
</style>
