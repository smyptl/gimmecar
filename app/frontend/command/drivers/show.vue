<script>
  import Moment     from 'moment'
  import Capitalize from 'lodash/capitalize'
  import SnackCase  from 'lodash/snakeCase'

  import ActionsIcon       from 'Components/icons/actions'
  import AddCard           from './driver/add_card'
  import DriverInformation from 'Components/driver/information'
  import Dropdown          from 'Components/dropdown'
  import SourcesIcon       from 'Components/driver/sources_icon'

  import RentalsTable      from 'Components/rental/table'

  import Currency from 'Filters/currency'
  import TDate from 'Filters/date'

  export default {
    name: 'Driver',
    data() {
      return {
        driver: {},
        insurance_policies: {},
        sources: {},
        rentals: {},
        metrics: {},
        action: '',
        tab: '',
      }
    },
    components: {
      ActionsIcon,
      AddCard,
      DriverInformation,
      Dropdown,
      RentalsTable,
      SourcesIcon,
    },
    filters: {
      Capitalize,
      Currency,
      date: TDate,
      time(val) {
        var val = Moment(val)

        if (val.isValid()) {
          return val.format('M/D/YY @ h:mm A')
        }
      },
    },
    created() {
      this.getData()
    },
    watch: {
      '$route': 'getData',
    },
    computed: {
      card_sources() {
        return(this.sources.data, n => {
          return n.object != 'card'
        })
      },
    },
    methods: {
      addCard() {
        return this.action = 'add-card'
      },
      getData() {
        this.$http.get(this.$route.path).then(response => {
          this.driver = response.data
        })
      },
      refreshData() {
        this.getData()
        this.view(this.tab)
        this.action = ''
      },
      tabActive(value) {
        return this.tab === value;
      },
      view(tab) {
        this.$http.get(this.$route.path + '/' + tab).then(response => {
          this[SnackCase(tab)] = response.data
          this.tab = tab
        })
      },
      viewRental(number) {
        this.$router.push({ name: 'rental', params: { number: number }})
      },
    },
  }
</script>

<template lang='pug'>
  div
    .panel.panel-base
      .panel-base-header
        h2 {{ driver.name_first }} {{ driver.name_last }}
        dropdown.flex-element.right
          a.right(href='#' data-toggle='dropdown')
            actions-icon.action-icon
          .dropdown-menu.right(slot='dropdown-menu')
            ul
              li
                button.link(@click='addCard') Add Card

      driver-information.left(:driver='driver')

    .sub-navigation
      ul.list-horizontal
        li
          a(@click.prevent='view("insurance-policies")' v-bind:class='{ active: tabActive("insurance-policies") }') Insurance Policies
        li(v-if='driver.rentals_closed_count > 0')
          a(@click.prevent='view("metrics")' v-bind:class='{ active: tabActive("metrics") }') Metrics
        li
          a(@click.prevent='view("rentals")' v-bind:class='{ active: tabActive("rentals") }') Rentals
        li(v-if='driver.stripe_id')
          a(@click.prevent='view("sources")' v-bind:class='{ active: tabActive("sources") }') Payment Sources

    template(v-if='tabActive("insurance-policies")')
      .panel.panel-base(
        v-for='policy in insurance_policies.data'
        :key='policy.id'
      )
        table.panel-table.panel-table-key-pair
          tbody
            tr
              td Company
              td {{ policy.company_name }}
            tr
              td Policy #
              td {{ policy.policy_number }}
            tr
              td Effective Date
              td {{ policy.effective_date | date }}
            tr
              td Expiration Date
              td {{ policy.expiration_date | date }}


    rentals-table(v-if='tabActive("rentals")'
                  :rentals='rentals'
                  :show_driver='false'
                  @view-rental='viewRental($event)')

    .panel.panel-base(v-if='tabActive("sources")')
      .gimmecar-app-vertical-scroll
        table.panel-table
          thead
            th(colspan='2') Source
            th.text-nowrap.text-right Last 4
            th.text-right Exp
            th.text-right CVC
            th.text-right Zip
          tbody
            tr(
              v-for='source in sources.data'
              :key='source.id'
            )

              template(v-if='source.object == "card"')
                td.source-icon
                  sources-icon(:brand='source.brand')
                td.text-nowrap {{ source.brand }} - {{ source.funding | capitalize }}
                td.text-nowrap.text-right {{ source.last4 }}
                td.text-right {{ source.exp_month }} / {{ source.exp_year }}
                td.text-right {{ source.cvc_check }}
                td.text-right {{ source.address_zip_check }}

              template(v-if='source.object == "bank_account"')
                td.source-icon
                  sources-icon(brand='default')
                td.text-nowrap {{ source.bank_name | capitalize }} - Bank
                td.text-nowrap.text-right {{ source.last4 }}
                td
                td
                td

    .panel.panel-base(v-if='tabActive("metrics")')
      table.panel-table.panel-table-key-pair
        thead
          tr
            th(colspan='2') Metrics
        tbody
          tr
            td Rentals
            td {{ metrics.rentals_count }}
          tr
            td Revenue
            td {{ metrics.sub_total | currency }}
          tr
            td Days Paid
            td {{ metrics.days_paid }}
          tr
            td Avg. Rate
            td {{ metrics.average_rate | currency }}
          tr
            td Miles Driven
            td {{ metrics.miles_driven }}
          tr
            td Avg. Miles / Day
            td {{ metrics.average_miles_per_day }}
          tr
            td Avg. Price / Mile
            td {{ metrics.average_price_per_mile | currency }}



    component(v-bind:is='action' @close='refreshData')
</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/table'
  @import '~Styles/components/panels/sub_navigation'

  .action-icon
    float: right
    height: 1.25rem

  .source-icon
    svg
      float: left
      display: inline-block

      height: 1.25rem
      width: auto

</style>
