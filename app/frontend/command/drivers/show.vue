<script>
  import Moment from 'moment'

  import ActionsIcon       from 'Components/icons/actions'
  import AddCard           from './driver/add_card'
  import DriverInformation from 'Components/driver/information'
  import Dropdown          from 'Components/dropdown'

  import Currency from 'Filters/currency'
  import TDate from 'Filters/date'

  export default {
    name: 'Driver',
    data () {
      return {
        driver: {},
        insurance_policies: {},
        rentals: {},
        action: '',
        tab: '',
      }
    },
    components: {
      ActionsIcon,
      AddCard,
      DriverInformation,
      Dropdown,
    },
    filters: {
      Currency,
      date: TDate,
      time (val) {
        var val = Moment(val)

        if (val.isValid()) {
          return val.format('M/D/YY @ h:mm A')
        }
      },
    },
    created () {
      this.getData()
    },
    watch: {
      '$route': 'getData',
    },
    methods: {
      addCard () {
        return this.action = 'add-card'
      },
      getData () {
        this.$http.get(this.$route.path).then(response => {
          this.driver = response.data
          this.insurance_policies = this.driver.insurance_policies
          this.tab = 'insurance-policies'
        })
      },
      refreshData () {

      },
      tabActive (value) {
        return this.tab === value;
      },
      view (tab) {
        this.$http.get(this.$route.path + '/' + tab).then(response => {
          this[tab] = response.data
          this.tab = tab
        })
      },
      viewRental (number) {
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
        li
          a(@click.prevent='view("rentals")' v-bind:class='{ active: tabActive("rentals") }') Rentals

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


    .panel.panel-base(v-if='tabActive("rentals")')
      .gimmecar-app-vertical-scroll
        table.panel-table
          thead
            tr
              th #
              th Location
              th Vehicle
              th Pickup
              th Drop Off
          tbody
            tr.clickable(
              v-for='rental in rentals.data'
              :key='rental.id'
              @click.prevent='viewRental(rental.number)'
            )

              td {{ rental.number }}
              td {{ rental.pickup_location_name }}
              td {{ rental.vehicle_make_model }}
              td {{ rental.pickup | time }}
              td {{ rental.drop_off | time }}

    component(v-bind:is='action' v-on:close='refreshData')
</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/table'
  @import '~Styles/components/panels/sub_navigation'

  .action-icon
    float: right
    height: 1.25rem

  .status
    vertical-align: center
</style>
