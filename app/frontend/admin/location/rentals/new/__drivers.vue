<script>
  import Shake from 'Utils/transitions/shake'

  import InputDate from 'Components/inputs/date'
  import DriverInformation from 'Components/driver/information'

  import Driver           from 'Admin/location/components/driver'
  import DriverAdditional from 'Admin/location/components/driver_additional'

  export default {
    name: 'Drivers',
    props: {
      form: {
        type: Object,
        required: true,
      },
    },
    data () {
      return {
        driver_search: false,
        search_result: null,
        search: new this.$form({
          name_first: null,
          name_last: null,
          date_of_birth: null,
        })
      }
    },
    components: {
      InputDate,
      DriverInformation,
      Driver,
      DriverAdditional,
    },
    methods: {
      searchDriver() {
        this.$http.post(this.$route.path + '/driver-search', {
          search: this.search.data(),
        })
        .then(response => {
          this.search.errors.clear()
          this.search_result = response.data
        })
        .catch(error => {
          this.search.errors.record(error.response.data.errors)
        })
      },
    },
  }
</script>

<template lang='pug'>
  div
    template(v-if='driver_search')
      driver.left(v-bind:form='form')
    .input-row(v-else)
      label.input-label(for='search_driver_name_first') Search

      .input-container.whole
        .input-container.two-thirds
          .input-container.one-half.fixed
            .input-block.whole
              input.input-field#search_name_first(
                type='text'
                placeholder='First'
                v-model='search.name_first'
                v-error='search.errors.has("name_first")'
                @input='search.errors.clear("name_first")')
            input-error-message(v-bind:errors='search.errors.get("name_first")')

          .input-container.one-half.fixed
            .input-block.whole
              input.input-field#search_name_last(
                type='text'
                placeholder='Last'
                v-model='search.name_last'
                v-error='search.errors.has("name_last")'
                @input='search.errors.clear("name_last")')
            input-error-message(v-bind:errors='search.errors.get("name_last")')

        .input-container.one-third
          .input-block.whole
            input-date.input-field#search_date_of_birth(
              placeholder='Date of Birth'
              v-model='search.date_of_birth'
              v-error='search.errors.has("date_of_birth")'
              @input='search.errors.clear("date_of_birth")')
          input-error-message(v-bind:errors='search.errors.get("date_of_birth")')

      .input-block.mt-ex-sm.whole
        button.btn.btn-primary.btn-sm.right(@click.prevent='searchDriver') Search

      .input-row.mt-default(v-if='search_result')
        .input-flex-container.input-block.whole
          .input-element-fixed
            input.input-field(type='checkbox' :disabled='search_result.do_not_rent')

          .input-element-flex
            .ml-sm
              .input-field#search-results
                h3 {{ search_result.name_first }} {{ search_result.name_last }}
                driver-information(:driver='search_result')

    .mt-sm.left
      template(v-if='form.add_additional_driver')
        a.link-danger(@click.prevent='form.add_additional_driver = false')
          h3.panel-form-header Remove Additional Driver
        driver-additional.left(v-bind:form='form')

      template(v-else)
        a.mt-sm(@click.prevent='form.add_additional_driver = true')
          h3.panel-form-header Add Additional Driver
</template>

<style lang='stylus' scoped>
  @import '~Styles/global/layout'

  .input-field#search-results
    overflow: hidden
    padding: 0

    h3
      margin: 0
      padding: $padding-default

</style>
