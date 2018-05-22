<script>
  import Shake from 'Utils/transitions/shake'
  import InputSubmit from 'Mixins/input_submit'

  export default {
    name: 'login',
    data() {
      return {
        form: new this.$form({
          email: '',
          password: '',
        }),
      }
    },
    mixins: [
      InputSubmit,
    ],
    methods: {
      loginUser() {
        this.inputSubmitStart()

        this.$http.post('/', this.form.data())
          .then(response => {
            this.inputSubmitFinish()
            this.$router.push({ name: 'locations' })
          })
          .catch(error => {
            Shake(document.getElementById('login-form'))
            this.inputSubmitFinish()
            this.form.errors.record(error.response.data.errors)
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
          input-error-message(:errors='form.errors.get("base")' :base='true')

          .input-container.whole
            .input-block
              label.input-label(for='email') Email:
              input.input-field#email(
                type='email'
                placeholder='hford@gimmecar.com'
                v-model='form.email'
                v-error='form.errors.has("email")'
                @input='form.errors.clear("email")')

              input-error-message(:errors='form.errors.get("email")')

          .input-container.whole
            .input-block
              label.input-label(for='password') Password:
              input.input-field#password(
                type='password'
                placeholder='!0nG-06scUr3-P@55wOrD'
                v-model='form.password'
                v-error='form.errors.has("password")'
                @input='form.errors.clear("password")')

              input-error-message(:errors='form.errors.get("password")')

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
