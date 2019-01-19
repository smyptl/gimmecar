<script>
  import Capitalize from 'lodash/capitalize'
  import Find from 'lodash/find'
  import VehicleStatusIcons from 'Components/vehicle/status'

  export default {
    name: 'Vehicles',
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
    components: {
      VehicleStatusIcons,
    },
    computed: {
      sorted_vehicles() {
        return this.vehicles.data
      },
      pickup_odometer_wrong() {
        if (this.vehicle && this.form.pickup_odometer) {
          return this.form.pickup_odometer > this.vehicle.odometer + 100;
        } else {
          return false;
        }
      },
      vehicle() {
        return Find(this.vehicles.data, ['id', this.form.vehicle_id]);
      }
    },
    methods: {
      lastFive(vin) {
        return vin.slice(-5)
      },
      selectVehicle(vehicle) {
        this.form.vehicle_id = vehicle.id;
        this.form.errors.clear('vehicle_id');
        return null;
      }
    },
  }
</script>

<template lang='pug'>
  div
    .input-block
      .input-field.input-field-table(v-error='form.errors.has("vehicle_id")')
        .gimmecar-app-vertical-scroll
          table.input-table
            thead
              tr
                th
                th
                th Make Model
                th Color
                th License #
            tbody
              tr(
                v-for='vehicle in sorted_vehicles'
                :key='vehicle.id'
                @click.prevent='selectVehicle(vehicle)'
                :class='{ selected: form.vehicle_id == vehicle.id }'
              )

                td.checkbox
                  input.input-field(type='radio' :checked='form.vehicle_id == vehicle.id')
                td.checkbox
                  vehicle-status-icons(:status='vehicle.status')
                td {{ vehicle.make_model }}
                td {{ vehicle.color | capitalize }}
                td(v-if='vehicle.license_number') {{ vehicle.license_number }}
                td(v-else)
                  i VIN: {{ lastFive(vehicle.vin) }}
      input-error-message(:errors='form.errors.get("vehicle_id")')

    .input-container.whole
      .input-container.two-fifths
        .input-block
          label.input-label(for='pickup_odometer') Vehicle Odometer
          input.input-field#pickup_odometer(type='text'
            v-model='form.pickup_odometer'
            v-error='form.errors.has("pickup_odometer")'
            @input='form.errors.clear("pickup_odometer")')
          input-error-message(:errors='form.errors.get("pickup_odometer")')

        .input-block(v-if='pickup_odometer_wrong')
          p.message.message-warning The pickup odometer looks incorrect, last odometer was {{ this.vehicle.odometer }}, please double check.

      .input-container.three-fifths
        .input-block
          label.input-label(for='pickup_fuel')
            | Fuel Level
            .input-label-note.right {{ form.pickup_fuel * 10 }}%
          input.input-range#pickup_fuel(type='range' v-model.number='form.pickup_fuel' min='0' max='10')
          input-error-message(:errors='form.errors.get("pickup_fuel")')
</template>

<style lang='stylus' scoped>
  @import '~Styles/global/colors'
  @import '~Styles/global/layout'
  @import '~Styles/components/panels/form'
  @import '~Styles/components/panels/table'

  .message-warning
    margin-top: $margin-sm

    padding: $padding-sm

    border-radius: $input-border-radius
    background: $yellow

    color: lighten($yellow, 98%)
    text-shadow: 0.0625rem 0 0.25rem darken($yellow, 15%)
    font-weight: 600
</style>
