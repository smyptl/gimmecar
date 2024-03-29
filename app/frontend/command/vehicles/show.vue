<script>
  import Moment from 'moment'

  import Dropdown           from 'Components/dropdown'
  import ActionsIcon        from 'Components/icons/actions'
  import VehicleInformation from 'Components/vehicle/information'
  import RentalsTable       from 'Components/rental/table'
  import MonthlyRevenue     from './vehicle/monthly_revenue'
  import RegistrationsList  from './vehicle/registrations'

  import Percent from 'Filters/percent'

  import AddRegistration from './vehicle/add_registration'

  export default {
    name: 'Vehicle',
    data() {
      return {
        vehicle: {},
        rentals: {},
        revenue: {},
        registrations: {},
        tab: '',
        loading: true,
        action: '',
        action_url: ''
      }
    },
    components: {
      ActionsIcon,
      AddRegistration,
      Dropdown,
      MonthlyRevenue,
      RentalsTable,
      RegistrationsList,
      VehicleInformation,
    },
    filters: {
      Percent,
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
      view(tab) {
        this.$http.get(this.$route.path + '/' + tab).then(response => {
          this[tab] = response.data
          this.tab = tab
        })
      },
      refreshData() {
        this.getData()
        this.action = ''
        this.view(this.tab)
      },
      addRegistration() {
        this.action_url = this.vehicle.actions['add_registration'].url
        this.action = 'addRegistration'
      },
      viewRental(number) {
        this.$router.push({ name: 'rental', params: { number: number }})
      },
      tabActive(value) {
        return this.tab === value;
      },
      getData() {
        this.$http.get(this.$route.path).then(response => {
          this.vehicle = response.data
          this.loading = false
        })
      },
    },
  }
</script>

<template lang='pug'>
  div(v-if='!loading')
    .panel.panel-base
      .panel-base-header
        h2 {{ vehicle.make }} {{ vehicle.model }}
        dropdown.flex-element.right
          a.right(href='#' data-toggle='dropdown')
            actions-icon.action-icon
          .dropdown-menu.right(slot='dropdown-menu')
            ul
              li
                button.link(@click='addRegistration()') Add Registration

      vehicle-information(:vehicle='vehicle' :show_location='true')
    .sub-navigation
      ul.list-horizontal
        li
          a(@click.prevent='view("rentals")' :class='{ active: tabActive("rentals") }') Rentals
        li
          a(@click.prevent='view("registrations")' :class='{ active: tabActive("registrations") }') Registrations
        li
          a(@click.prevent='view("revenue")' :class='{ active: tabActive("revenue") }') Revenue

    rentals-table(v-if='tabActive("rentals")'
                  :rentals='rentals'
                  :show_vehicle='false'
                  @view-rental='viewRental($event)')

    monthly-revenue(v-if='tabActive("revenue")'
                    :revenue='revenue')

    registrations-list(v-if='tabActive("registrations")'
                       :registrations='registrations')


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
</style>
