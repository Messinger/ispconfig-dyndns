<template>
  <div id="user_password_edit">
    <v-card>
      <v-card-title>
        <h3>Password ändern</h3>
      </v-card-title>
      <v-card-text>
        <v-form ref="pwform" v-model="valid" lazy-validation id="pwform" @keyup.enter.native="submit_password">
          <password-input ref="passwordinput" :reset_password_token="reset_password_token"></password-input>
        </v-form>
      </v-card-text>
    </v-card>
  </div>
</template>

<script lang="coffee">

  import password_input from '../shared/password_input'

  export default {
    name: "user_password_edit"

    components: {
      'password-input': password_input
    }

    watch: {
      "$route": (to,from) ->
        this.reset_password_token = this.$attrs.reset_password_token

    }
    data: () ->
      {
        reset_password_token: null
        valid: false
        userdata: {}
        target_url: ''
      }

    mounted: () ->
      this.reset_password_token = this.$attrs.reset_password_token
      window.ichbins = this

    methods: {
      submit_password: () ->
        that = this
        userdata = this.$refs.passwordinput.$data
        user = {
          password: userdata.password
          password_confirmation: userdata.password_confirmation
        }
        if !!this.reset_password_token
          user.reset_password_token = this.reset_password_token
        else
          user.current_password = userdata.current_password

        this.$root.axios.put('/users/password',{user: user}).then(
            (resut) ->
              console.log "PW Ändern: ",result
              that.$root.$update_user()
        ).catch(
          (error) ->
            console.log error.data
            if !!error.data.errors && !!error.data.errors['password']
              for msg in that.$root.$errors_to_array(error.data.errors)
                that.$root.$toast.alert(msg,color: 'alarm')
            else
                that.$root.$toast.alert((error.data||'Fehler'))
        )
    }
  }

</script>

<style scoped>

</style>