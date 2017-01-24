<script>
  import Form from 'Utils/form'

  import InputError from 'Components/inputs/error'
  import InputErrorMessage from 'Components/inputs/error_message'

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
    components: {
      InputErrorMessage,
    },
    directives: {
      error: InputError,
    },
    methods: {
      loginUser () {
        this.$http.post(this.$route.path, {
            login: this.login.data()
          })
          .then(response => {
            USER = response.data.user
            LOCATION = response.data.locations[0]
            this.$router.push({ name: 'dashboard', params: { location: LOCATION.slug } })
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

      #login-form
        form(@submit.prevent='loginUser()')
          .input-row
            label.input-label Email:
            .input-block.whole
              input.input-field(
                type='email'
                placeholder='hford@gimmecar.com'
                v-model='login.email'
                v-error='login.errors.has("email")'
                @input='login.errors.clear("email")')

            input-error-message(field='email' v-bind:errors='login.errors.get("email")')

          .input-row
            label.input-label Password:
            .input-block.whole
              input.input-field(
                type='password'
                placeholder='!0nG-06scUr3-P@55wOrD'
                v-model='login.password'
                v-error='login.errors.has("password")'
                @input='login.errors.clear("password")')

            input-error-message(field='email' v-bind:errors='login.errors.get("password")')

          .input-submit.input-block
            input.btn.btn-primary.right(type='submit' value='Login')

</template>

<style lang='stylus' scoped>
  @import '~Styles/global/layout'

  #login
    height: 100vh
    display: flex

  #login-container
    width: 20rem
    margin: 0 auto 5rem
    align-self: center

    padding: 0 $padding-default

</style>
