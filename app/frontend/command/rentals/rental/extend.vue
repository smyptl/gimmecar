<script>
  import Shake from 'Utils/transitions/shake'

  import InputSubmit from 'Mixins/input_submit'
  import Capitalize from 'lodash/capitalize'

  import InputCurrency from 'Components/inputs/currency'
  import InputDate     from 'Components/inputs/date'
  import Popup         from 'Components/popup'
  import SourcesIcon   from 'Components/driver/sources_icon'

  export default {
    name: 'RentalExtend',
    props: {
      url: {
        type: String,
        required: true
      }
    },
    data() {
      return {
        open: false,
        rental: {},
        form: new this.$form({
          date: '',
          days: 1,
          amount: '',
          customer_id: '',
          source_id: '',
        }),
      }
    },
    mixins: [
      InputSubmit,
    ],
    filters: {
      Capitalize,
    },
    components: {
      InputCurrency,
      InputDate,
      Popup,
      SourcesIcon,
    },
    mounted() {
      this.$http.get(this.url).then(response => {
        this.rental = response.data;
        this.form.amount = this.rental.rental_last_rate_amount;
        this.form.date   = this.rental.drop_off;

        if (this.rental.driver_default_source) {
          this.form.customer_id = this.rental.driver_stripe_id;
          this.form.source_id = this.rental.driver_default_source;
        } else if (this.rental.additional_driver_default_source) {
          this.form.customer_id = this.rental.additional_driver_stripe_id;
          this.form.source_id = this.rental.additional_driver_default_source;
        }
      })

      this.open = true
    },
    computed: {
      driver_sources() {
        return this.rental.driver_sources.data;
      },
    },
    methods: {
      selectSource(source) {
        this.form.customer_id = source.customer;
        this.form.source_id = source.id;
        this.form.errors.clear('source_id');
        return null;
      },
      sourceSelected(source) {
        return this.form.customer_id == source.customer && this.form.source_id == source.id;
      },
      close() {
        this.$emit('close')
      },
      extendRental() {
        this.inputSubmitStart()

        this.$http.post(this.url, this.form.data())
          .then(response => {
            this.form.errors.clear()
            this.inputSubmitFinish()
            this.close()
          })
          .catch(error => {
            this.form.errors.record(error.response.data.errors)
            this.inputSubmitFinish()
          })
      },
    },
  }
</script>

<template lang='pug'>
  popup(v-if='open' @closed='close')
    .panel-form-popup
      .panel-form.panel-form-padding
        h4.panel-form-popup-header Extend

      .panel-form.panel-form-padding.panel-popup-form-content
        .input-block.mt-default.mb-sm(v-if='form.errors.has("base")')
            input-error-message(:base='true' :errors='form.errors.get("base")')

        .input-container.whole
          .input-container.two-fifths.fixed
            .input-block
              label.input-label(for='date') Date
              input-date#date(
                v-model='form.date'
                v-error='form.errors.has("date")'
                @input='form.errors.clear("date")')
              input-error-message(:errors='form.errors.get("date")')

          .input-container.one-fifth.fixed
            .input-block
              label.input-label(for='days') Days
              input.input-field#days(
                type='text'
                v-model='form.days'
                v-error='form.errors.has("days")'
                @input='form.errors.clear("days")')
              input-error-message(:errors='form.errors.get("days")')

          .input-container.two-fifths.fixed
            .input-block
              label.input-label(for='amount') Amount
              input-currency#amount(
                v-model='form.amount'
                v-error='form.errors.has("amount")'
                @input='form.errors.clear("amount")')
              input-error-message(:errors='form.errors.get("amount")')

        .input-container.whole
          .input-block
            label.input-label Payment
            .input-field.input-field-table(v-error='form.errors.has("source_id")')
              .gimmecar-app-vertical-scroll
                table.input-table
                  template(v-if='rental.driver_stripe_id')
                    thead
                      tr
                        th(colspan='5') {{ rental.driver_name }} (Driver)
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
                          td.text-nowrap.text-right {{ source.last4 }}
                          td --

                  template(v-if='rental.additional_driver_stripe_id')
                    thead
                      tr
                        th(colspan='5') {{ rental.additional_driver_name }} (Driver - Additional)
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
                          td.text-nowrap.text-right {{ source.last4 }}
                          td --

            input-error-message(:errors='form.errors.get("source_id")')

      .panel-form.panel-form-padding.panel-popup-form-footer
        .input-submit.input-block
          input-submit.btn.btn-primary.right(@click.native.prevent='extendRental()' :loading='input_submit_loading') Extend
</template>

<style lang='stylus' scoped>
  @import '~Styles/components/panels/form'
  @import '~Styles/components/inputs/table'

  .source-icon
    svg
      float: left
      display: inline-block

      height: 1.25rem
      width: auto

</style>
