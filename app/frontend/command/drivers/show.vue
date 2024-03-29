<script>
  import Moment     from 'moment'
  import Capitalize from 'lodash/capitalize'
  import SnackCase  from 'lodash/snakeCase'
  import CamelCase  from 'lodash/camelCase'

  import AddCard           from './driver/add_card'
  import AddContactInfo    from './driver/add_contact_info'

  import ActionsIcon       from 'Components/icons/actions'
  import DriverInformation from 'Components/driver/information'
  import Dropdown          from 'Components/dropdown'
  import SourcesIcon       from 'Components/driver/sources_icon'
  import RentalsTable      from 'Components/rental/table'
  import InsurancePolicies from 'Components/driver/insurance_policies'

  import Currency from 'Filters/currency'

  export default {
    name: 'Driver',
    data() {
      return {
        driver: {},
        tab: '',
        insurance_policies: {},
        sources: {},
        rentals: {},
        metrics: {},
        action: '',
        action_url: '',
      }
    },
    components: {
      ActionsIcon,
      AddCard,
      AddContactInfo,
      DriverInformation,
      InsurancePolicies,
      Dropdown,
      RentalsTable,
      SourcesIcon,
    },
    filters: {
      Capitalize,
      Currency,
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
    methods: {
      addCard() {
        return this.action = 'add-card'
      },
      getData() {
        this.$http.get(this.$route.path).then(response => {
          this.driver = response.data
        })
      },
      loadAction(action) {
        this.action_url = this.driver.actions[action].url
        this.action = CamelCase(action)
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
                button.link(@click='loadAction("add_card")') Add Card
              li
                button.link(@click='loadAction("add_contact_info")') Add Contact Info

      driver-information.left(:driver='driver')

    .sub-navigation
      ul.list-horizontal
        li
          a(@click.prevent='view("insurance-policies")' :class='{ active: tabActive("insurance-policies") }') Insurance Policies
        li(v-if='driver.rentals_closed_count > 0')
          a(@click.prevent='view("metrics")' :class='{ active: tabActive("metrics") }') Metrics
        li
          a(@click.prevent='view("rentals")' :class='{ active: tabActive("rentals") }') Rentals
        li(v-if='driver.stripe_id')
          a(@click.prevent='view("sources")' :class='{ active: tabActive("sources") }') Payment Sources

    insurance-policies(
      v-if='tabActive("insurance-policies")'
      :insurance_policies='insurance_policies'
    )

    rentals-table(
      v-if='tabActive("rentals")'
      :rentals='rentals'
      :show_driver='false'
      @view-rental='viewRental($event)'
    )

    .panel.panel-base(v-if='tabActive("sources")')
      .gimmecar-app-vertical-scroll
        table.panel-table
          thead
            th(colspan='2') Source
            th.text-nowrap.text-right Last 4
            th.text-right Exp
          tbody
            tr(
              v-for='source in sources.data'
              :key='source.id'
            )

              template(v-if='source.object == "card"')
                td.source-icon.status
                  sources-icon(:brand='source.brand')
                td.text-nowrap {{ source.brand }} - {{ source.funding | capitalize }}
                td.text-nowrap.text-right •••• {{ source.last4 }}
                td.text-right {{ source.exp_month }} / {{ source.exp_year }}

              template(v-if='source.object == "bank_account"')
                td.source-icon
                  sources-icon(brand='default')
                td.text-nowrap {{ source.bank_name | capitalize }} - Bank
                td.text-nowrap.text-right {{ source.last4 }}
                td --

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


    component(:is='action'
              :url='action_url'
              @close='refreshData')
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
