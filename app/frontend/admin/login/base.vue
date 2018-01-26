<script>
  import Form from 'Utils/form'

  import Shake from 'Utils/transitions/shake'

  export default {
    name: 'login',
    data () {
      return {
        login: new Form({
          email: '',
          password: '',
        }),
      }
    },
    methods: {
      loginUser () {
        this.$http.post('/', {
            login: this.login.data()
          })
          .then(response => {
            window.location = '/locations'
          })
          .catch(error => {
            Shake(document.getElementById('login-form'))
            this.login.errors.record(error.response.data.errors)
          })
      },
    },
  }

</script>

<template lang='pug'>
  #login
    #login-container
      h1.logo.logo-vertical.margin-bottom-lg.text-center
        | GimmeCar
        small Admin

      #login-form.margin-top-sm
        form(@submit.prevent='loginUser()')
          input-error-message(v-bind:errors='login.errors.get("base")' :base='true')

          .input-row
            label.input-label(for='email') Email:
            .input-block.whole
              input.input-field#email(
                type='email'
                placeholder='hford@gimmecar.com'
                v-model='login.email'
                v-error='login.errors.has("email")'
                @input='login.errors.clear("email")')

            input-error-message(v-bind:errors='login.errors.get("email")')

          .input-row
            label.input-label(for='password') Password:
            .input-block.whole
              input.input-field#password(
                type='password'
                placeholder='!0nG-06scUr3-P@55wOrD'
                v-model='login.password'
                v-error='login.errors.has("password")'
                @input='login.errors.clear("password")')

            input-error-message(v-bind:errors='login.errors.get("password")')

          .input-submit.input-block
            input.btn.btn-primary.right(type='submit' value='Login')

</template>

<style lang='stylus' scoped>
  @import '~Styles/global/layout'
  @import '~Styles/global/colors'

  #login
    background-color: $background-color-contrast
    height: 100vh
    display: flex

  #login-container
    width: 20rem
    margin: 0 auto 5rem
    align-self: center

    padding: 0 $padding-default

</style>
