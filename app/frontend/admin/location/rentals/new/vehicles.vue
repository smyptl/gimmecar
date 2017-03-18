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
            td {{ vehicle.license_number }}

    .input-row.margin-top-default
      .input-container.two-fifths
        label.input-label(for='pickup_odometer') Vehicle Odometer
        .input-block.whole
          input.input-field#pickup_odometer(type='text' v-model='form.pickup_odometer')
      .input-container.three-fifths
        label.input-label(for='pickup_fuel')
          | Fuel Level
          .input-label-note.right {{ form.pickup_fuel * 10 }}%
        .input-block.whole
          input.input-range#pickup_fuel(type='range' v-model.number='form.pickup_fuel' min='0' max='10')
</template>
