<script>
  import Capitalize from 'lodash/capitalize'

  export default {
    props: {
      value: {
        required: true,
      },
      name: {
        type: String,
      },
    },
    data () {
      return {
        vehicle_types: {
          subcompact: 'Toyota Yaris iA',
          compact: 'Toyota Corolla',
        },
      }
    },
    filters: {
      Capitalize,
    },
    methods: {
      selectVehicleType(vehicle_type) {
        this.$emit('input', vehicle_type)
      },
    }
  }
</script>

<template lang='pug'>
  .input-field.input-field-table
    table.input-table
      tbody
        tr(
          v-for='(example, type) in vehicle_types'
          :key='type'
          @click.prevent='selectVehicleType(type)'
          :class='{ selected: value == type }'
        )

          td.checkbox
            input.input-field(type='radio' :id="'vehicle_type_' + type" :checked='value == type')
          td
            label.cursor-pointer.whole(:id="'vehicle_type_' + type") {{ type | capitalize }} ({{ example }})
</template>

<style lang='stylus'>
  @import '~Styles/components/inputs/table'
</style>
