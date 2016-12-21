<script>
  import InputDate from 'Components/inputs/date'

  export default {
    data() {
      return {
        pickup_date: '',
        pickup_time: '0900',
        return_date: '',
        return_time: '0900',
      }
    },
    components: {
      InputDate,
    },
  }
</script>

<template lang='pug'>
  .style-free-wrapper
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
          select.input-field.input-lg(name='pickup_time' v-model='pickup_time' placeholder='--:-- AM/PM')
            option(value='' disabled) --:-- AM/PM
            option(value='0000') 12:00 AM
            option(value='0030') 12:30 AM
            option(value='0100') 1:00 AM
            option(value='0130') 1:30 AM
            option(value='0200') 2:00 AM
            option(value='0230') 2:30 AM
            option(value='0300') 3:00 AM
            option(value='0330') 3:30 AM
            option(value='0400') 4:00 AM
            option(value='0430') 4:30 AM
            option(value='0500') 5:00 AM
            option(value='0530') 5:30 AM
            option(value='0600') 6:00 AM
            option(value='0630') 6:30 AM
            option(value='0700') 7:00 AM
            option(value='0730') 7:30 AM
            option(value='0800') 8:00 AM
            option(value='0830') 8:30 AM
            option(value='0800') 8:00 AM
            option(value='0830') 8:30 AM
            option(value='0900') 9:00 AM
            option(value='0930') 9:30 AM
            option(value='1000') 10:00 AM
            option(value='1030') 10:30 AM
            option(value='1100') 11:00 AM
            option(value='1130') 11:30 AM
            option(value='1200') 12:00 PM
            option(value='1230') 12:30 PM
            option(value='1300') 1:00 PM
            option(value='1330') 1:30 PM
            option(value='1400') 2:00 PM
            option(value='1430') 2:30 PM
            option(value='1500') 3:00 PM
            option(value='1530') 3:30 PM
            option(value='1600') 4:00 PM
            option(value='1630') 4:30 PM
            option(value='1700') 5:00 PM
            option(value='1730') 5:30 PM
            option(value='1800') 6:00 PM
            option(value='1830') 6:30 PM
            option(value='1900') 7:00 PM
            option(value='1930') 7:30 PM
            option(value='2000') 8:00 PM
            option(value='2030') 8:30 PM
            option(value='2100') 9:00 PM
            option(value='2130') 9:30 PM
            option(value='2200') 10:00 PM
            option(value='2230') 10:30 PM
            option(value='2300') 11:00 PM
            option(value='2330') 11:30 PM

      .input-container.one-half
        label.input-label To:
        .input-block.one-half.fixed
          input-date.input-lg(v-model='return_date' name='return_date')
        .input-block.one-half.fixed
          select.input-field.input-lg(name='return_time' v-model='return_time' placeholder='--:-- AM/PM')
            option(value='' disabled) --:-- AM/PM
            option(value='0000') 12:00 AM
            option(value='0030') 12:30 AM
            option(value='0100') 1:00 AM
            option(value='0130') 1:30 AM
            option(value='0200') 2:00 AM
            option(value='0230') 2:30 AM
            option(value='0300') 3:00 AM
            option(value='0330') 3:30 AM
            option(value='0400') 4:00 AM
            option(value='0430') 4:30 AM
            option(value='0500') 5:00 AM
            option(value='0530') 5:30 AM
            option(value='0600') 6:00 AM
            option(value='0630') 6:30 AM
            option(value='0700') 7:00 AM
            option(value='0730') 7:30 AM
            option(value='0800') 8:00 AM
            option(value='0830') 8:30 AM
            option(value='0800') 8:00 AM
            option(value='0830') 8:30 AM
            option(value='0900') 9:00 AM
            option(value='0930') 9:30 AM
            option(value='1000') 10:00 AM
            option(value='1030') 10:30 AM
            option(value='1100') 11:00 AM
            option(value='1130') 11:30 AM
            option(value='1200') 12:00 PM
            option(value='1230') 12:30 PM
            option(value='1300') 1:00 PM
            option(value='1330') 1:30 PM
            option(value='1400') 2:00 PM
            option(value='1430') 2:30 PM
            option(value='1500') 3:00 PM
            option(value='1530') 3:30 PM
            option(value='1600') 4:00 PM
            option(value='1630') 4:30 PM
            option(value='1700') 5:00 PM
            option(value='1730') 5:30 PM
            option(value='1800') 6:00 PM
            option(value='1830') 6:30 PM
            option(value='1900') 7:00 PM
            option(value='1930') 7:30 PM
            option(value='2000') 8:00 PM
            option(value='2030') 8:30 PM
            option(value='2100') 9:00 PM
            option(value='2130') 9:30 PM
            option(value='2200') 10:00 PM
            option(value='2230') 10:30 PM
            option(value='2300') 11:00 PM
            option(value='2330') 11:30 PM

      .input-submit
        .input-block
          button.btn.btn-full.btn-primary.left(type='submit') Continue
</template>
