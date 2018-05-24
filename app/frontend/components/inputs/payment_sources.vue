<script>
  import Capitalize from 'lodash/capitalize'
  import SourcesIcon from 'Components/driver/sources_icon'

  export default {
    name: 'Input-Payment-Sources',
    props: {
      value: {
        required: true,
      },
      sources: {
        required: true,
        type: Object,
      },
      error: {
        required: false,
        type: Boolean,
        default: false,
      },
    },
    mounted() {
      let source = {
        customer: '',
        id: '',
      };

      if (this.driver.stripe_default_source) {
        source.customer = this.driver.stripe_id;
        source.id       = this.driver.stripe_default_source;
      } else if (this.additional_driver.stripe_default_source) {
        source.customer = this.additional_driver.stripe_id;
        source.id       = this.additional_driver.stripe_default_source;
      }

      this.selectSource(source);
    },
    filters: {
      Capitalize,
    },
    components: {
      SourcesIcon,
    },
    computed: {
      driver() {
        return this.sources.driver;
      },
      additional_driver() {
        return this.sources.additional_driver;
      },
      hasDriverSources() {
        return this.driver && this.driver.stripe_id;
      },
      hasAdditionalDriverSources() {
        return this.additional_driver && this.additional_driver.stripe_id;
      },
      driver_sources() {
        if (this.hasDriverSources) {
          return this.driver.stripe_sources.data;
        }
      },
      additional_driver_sources() {
        if (this.hasAdditionalDriverSources) {
          return this.additional_driver.stripe_sources.data;
        }
      },
    },
    methods: {
      selectSource(source) {
        this.$emit('input', {
          customer_id: source.customer,
          source_id: source.id,
        });
      },
      sourceSelected(source) {
        return this.value.customer_id == source.customer && this.value.source_id == source.id;
      },
    },
  };
</script>

<template lang='pug'>
  .input-field.input-field-table
    .gimmecar-app-vertical-scroll
      table.input-table
        template(v-if='hasDriverSources')
          thead
            tr
              th(colspan='5') {{ driver.name }} (Driver)
          tbody
            tr(
              v-for='source in driver_sources'
              :key='source.id'
              @click.prevent='selectSource(source)'
              :class='{ selected: sourceSelected(source) }'
            )
              td.checkbox
                input.input-field(type='radio'
                                  :checked='sourceSelected(source)')
              template(v-if='source.object == "card"')
                td.source-icon.status
                  sources-icon(:brand='source.brand')
                td.text-nowrap {{ source.brand }} - {{ source.funding | capitalize }}
                td.text-nowrap.text-right •••• {{ source.last4 }}
                td.text-nowrap.text-right {{ source.exp_month }} / {{ source.exp_year }}

              template(v-if='source.object == "bank_account"')
                td.source-icon
                  sources-icon(brand='default')
                td.text-nowrap {{ source.bank_name | capitalize }} - Bank
                td.text-nowrap.text-right •••• {{ source.last4 }}
                td.text-right --

        template(v-if='hasAdditionalDriverSources')
          thead
            tr
              th(colspan='5') {{ additional_driver.name }} (Driver - Additional)
          tbody
            tr(
              v-for='source in additional_driver_sources'
              :key='source.id'
              @click.prevent='selectSource(source)'
              :class='{ selected: sourceSelected(source) }'
            )
              td.checkbox
                input.input-field(type='radio'
                                  :checked='sourceSelected(source)')
              template(v-if='source.object == "card"')
                td.source-icon.status
                  sources-icon(:brand='source.brand')
                td.text-nowrap {{ source.brand }} - {{ source.funding | capitalize }}
                td.text-nowrap.text-right •••• {{ source.last4 }}
                td.text-nowrap.text-right {{ source.exp_month }} / {{ source.exp_year }}

              template(v-if='source.object == "bank_account"')
                td.source-icon
                  sources-icon(brand='default')
                td.text-nowrap {{ source.bank_name | capitalize }} - Bank
                td.text-nowrap.text-right •••• {{ source.last4 }}
                td.text-right --
</template>

<style lang='stylus' scoped>
  @import '~Styles/components/inputs/table'

  .source-icon
    svg
      float: left
      display: inline-block

      height: 1.25rem
      width: auto

</style>
