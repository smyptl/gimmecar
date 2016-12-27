<script>
  import Snabbt from 'snabbt.js'

  import InputDate from 'Components/inputs/date'
  import InputTime from 'Components/inputs/time'

  export default {
    name: "reservation",
    data() {
      return {
        current_step: 'rental-details',
        new_reservation: false,
        pickup_date: new Date,
        pickup_time: '0900',
        return_date: new Date().setDate(new Date().getDate() + 3),
        return_time: '0900',
        leaving_element_height: null,
        entering_element_height: null,
        transition_type: 'forward',
      }
    },
    components: {
      InputDate,
      InputTime,
    },
    methods: {
      viewRates() {
        this.transition_type = 'forward'
        this.current_step = 'rental-summary'
      },
      newReservation() {
        this.transition_type = 'forward'
        this.current_step = 'rental-reserve'
      },
      enter(el, done) {
        if (this.transition_type == 'forward') {
          this.fadeIn(el, done, { scale: [1, 1], fromScale: [0.99, 0.99]})
        } else {
          this.fadeIn(el, done, { scale: [1, 1], fromScale: [1.01, 1.01]})
        }
      },
      leave(el, done) {
        if (this.transition_type == 'forward') {
          this.fadeOut(el, done, { scale: [1.01, 1.01], fromScale: [1, 1]})
        } else {
          this.fadeOut(el, done, { scale: [0.99, 0.99], fromScale: [1, 1]})
        }
      },
      fadeIn(el, done, settings) {
        Snabbt(el, {
          opacity: 1,
          fromOpacity: 0.01,
          scale: settings.scale,
          fromScale: settings.fromScale,
          easing: 'ease',
          duration: 200,
          complete() {
            done()
          },
        })
      },
      fadeOut(el, done, settings) {
        Snabbt(el, {
          opacity: 0.01,
          fromOpacity: 1,
          scale: settings.scale,
          fromScale: settings.fromScale,
          easing: 'ease',
          duration: 200,
          complete() {
            done()
          },
        })
      }
    },
  }
</script>

<template lang='pug'>
  transition(
    mode='out-in'
    v-on:enter='enter'
    v-on:leave='leave')

    #rental-details(v-if="current_step == 'rental-details'" key='details')
      .input-row
        label.input-label.input-lg Where:
        .input-block
          select.input-field.input-lg
            option(value='' disabled) Current, our only location.
            option(value='') Super 8 Redlands - 1160 Arizona St., Redlands, CA 92374

      .input-row
        .input-container.one-half
          label.input-label.input-lg From:

          .input-block.one-half.fixed
            input-date.input-lg(v-model='pickup_date' name='pickup_date')
          .input-block.one-half.fixed
            input-time.input-lg(v-model='pickup_time' name='pickup_time')

        .input-container.one-half
          label.input-label.input-lg To:
          .input-block.one-half.fixed
            input-date.input-lg(v-model='return_date' name='return_date')
          .input-block.one-half.fixed
            input-time.input-lg(v-model='return_time' name='return_time')

        .input-submit
          .input-block
            button.btn.btn-full.btn-primary.left(type='submit' @click='viewRates') View Rates

    #rental-summary(v-if="current_step == 'rental-summary'" key='summary')
      .input-block.margin-top-default
        h6.margin-bottom-sm Rental Details
        ul.left.whole.list-no-style
          li
            | Vehicle:&nbsp;
            b Toyota Corolla
          li
            | Location:&nbsp;
            b Super 8 Redlands - 1160 Arizona St. Redlands, CA 92374

          li
            | Pick Up:&nbsp;
            b {{ pickup_date }} @ {{ pickup_time }}

          li
            | Return:&nbsp;
            b {{ return_date }} @ {{ return_time }}


        h6.margin-bottom-sm Rates
        ul.left.whole.list-no-style
          li
            .left 12/1/2014
            .right $40
          li
            .left 12/2/2014
            .right $30

        h6.margin-bottom-sm Taxes & Fees
        ul.left.whole.list-no-style
          li
            .left Sales (8%)
            .right $5.60

        h5
          | Estimated Total:
          .right $75.60


        .input-submit
          button.btn.btn-full(@click="current_step = 'rental-details', transition_type = 'backward'") Go Back
          button.btn.btn-primary.btn-full(@click='newReservation') Reserve

    #rental-reserve(v-if="current_step == 'rental-reserve'" key='reserve')
      .input-row
        label.input-label.input-lg Name
        .input-block.one-half.fixed
          input.input-field.input-lg(type='text' placeholder='First')
        .input-block.one-half.fixed
          input.input-field.input-lg(type='text' placeholder='Last')

      .input-row
        label.input-label.input-lg
          | Email
          span.input-label-note.text-warning.right Valid email must be provided to confirm reservation.

        .input-block
          input.input-field.input-lg(type='text' placeholder='johndoe@url.com')

      .input-row
        label.input-label.input-lg
          | Phone #
          span.input-label-note.text-warning.right Valid number must be provided to confirm reservation.

        .input-block
          input.input-field.input-lg(type='text' placeholder='805.555.1234')

      .input-submit
        .input-block.one-fifth.fixed
          button.btn.btn-full(@click="current_step = 'rental-summary', transition_type = 'backward'") Go Back
        .input-block.four-fifths.fixed
          button.btn.btn-full.btn-primary Reserve Car

    #rental-confirmation(v-if="current_step == 'rental-confirmation'" key='reserve')


</template>
