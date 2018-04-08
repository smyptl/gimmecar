<script>
  import Shake from 'Utils/transitions/shake'
  import InputSubmit from 'Mixins/input_submit'

  export default {
    name: 'login',
    data () {
      return {
        login: new this.$form({
          email: '',
          password: '',
        }),
      }
    },
    mixins: [
      InputSubmit,
    ],
    methods: {
      loginUser () {
        this.inputSubmitStart()

        this.$http.post('/', {
            login: this.login.data()
          })
          .then(response => {
            this.inputSubmitFinish()
            this.$router.push({ name: 'locations' })
          })
          .catch(error => {
            Shake(document.getElementById('login-form'))
            this.inputSubmitFinish()
            this.login.errors.record(error.response.data.errors)
          })
      },
    },
  }

</script>

<template lang='pug'>
  #login
    #login-container
      h1.logo.logo-vertical.mb-lg.text-center
        | GimmeCar
        small Admin

      #login-form.mt-sm
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
            input-submit.btn.btn-primary.right(:loading='input_submit_loading') Login

</template>

<style lang='stylus' scoped>
  @import '~Styles/global/layout'
  @import '~Styles/global/colors'

  #login
    height: 100vh
    display: flex

  #login-container
    width: 20rem
    margin: 0 auto 5rem
    align-self: center

    padding: 0 $padding-default

</style>
