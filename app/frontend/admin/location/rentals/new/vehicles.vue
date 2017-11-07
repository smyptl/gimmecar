<script>
  import Capitalize from 'lodash/capitalize'

  export default {
    props: {
      form: {
        type: Object,
        required: true,
      },
      vehicles: {
        type: Array,
        required: true,
      },
    },
    filters: {
      Capitalize,
    },
    methods: {
      lastFive(vin) {
        return vin.slice(-5)
      }
    }
  }
</script>

<template lang='pug'>
  div
    .input-block.whole
      table.panel-table
        thead
          tr
            th
            th Make - Model
            th Color
            th License #
        tbody
          tr(v-for='vehicle in vehicles' @click.prevent='form.vehicle_id = vehicle.id' v-bind:class='{ selected: form.vehicle_id == vehicle.id }')
            td.checkbox
              button.button-checkbox
            td {{ vehicle.make }} {{ vehicle.model }}
            td {{ vehicle.color | capitalize }}
            td(v-if='vehicle.license_number') {{ vehicle.license_number }}
            td(v-else)
              i VIN: {{ lastFive(vehicle.vin) }}

    .input-row.margin-top-default
      .input-container.two-fifths
        label.input-label(for='pickup_odometer') Vehicle Odometer *
        .input-block.whole
          input.input-field#pickup_odometer(type='text'
            v-model='form.pickup_odometer'
            v-error='form.errors.has("pickup_odometer")'
            @input='form.errors.clear("pickup_odometer")')
        input-error-message(v-bind:errors='form.errors.get("pickup_odometer")')

      .input-container.three-fifths
        label.input-label(for='pickup_fuel')
          | Fuel Level *
          .input-label-note.right {{ form.pickup_fuel * 10 }}%
        .input-block.whole
          input.input-range#pickup_fuel(type='range' v-model.number='form.pickup_fuel' min='0' max='10')
        input-error-message(v-bind:errors='form.errors.get("pickup_fuel")')
</template>
