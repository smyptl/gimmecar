<script>
  import Capitalize from 'lodash/capitalize'

  export default {
    name: 'vehicles',
    props: {
      form: {
        type: Object,
        required: true,
      },
      vehicles: {
        type: Object,
        required: true,
      },
    },
    filters: {
      Capitalize,
    },
    computed: {
      sorted_vehicles () {
        return this.vehicles.data
      },
    },
    methods: {
      lastFive(vin) {
        return vin.slice(-5)
      },
      selectVehicle(vehicle_id) {
        this.form.vehicle_id = vehicle_id
        this.form.errors.clear('vehicle_id')
        return null
      }
    }
  }
</script>

<template lang='pug'>
  div
    input-error-message(v-bind:base='true' v-bind:errors='form.errors.get("vehicle_id")')
    .input-block.whole
      table.panel-table
        thead
          tr
            th
            th Make - Model
            th Color
            th License #
        tbody
          tr(v-for='vehicle in sorted_vehicles' @click.prevent='selectVehicle(vehicle.id)' v-bind:class='{ selected: form.vehicle_id == vehicle.id }')
            td.checkbox
              input.input-field(type='radio' id='form_vehicle_id' v-error='form.errors.has("vehicle_id")' v-bind:checked='form.vehicle_id == vehicle.id')
            td {{ vehicle.make_model }}
            td {{ vehicle.color | capitalize }}
            td(v-if='vehicle.license_number') {{ vehicle.license_number }}
            td(v-else)
              i VIN: {{ lastFive(vehicle.vin) }}

    .input-row.mt-default
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

<style lang='stylus' scoped>
  @import '~Styles/components/panels/table'

  input[type=radio].input-field
    margin: 0
</style>
