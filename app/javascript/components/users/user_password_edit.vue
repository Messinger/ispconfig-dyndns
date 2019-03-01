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
      <v-card-actions class="pt-0">
        <v-btn :disabled="!valid" color="primary darken-1" flat="flat" @click.native="submit_password">Ändere Passwort</v-btn>
      </v-card-actions>
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
        return unless (this.$refs.pwform.validate())
        userdata = this.$refs.passwordinput.$data
        user = {
          password: userdata.password
          password_confirmation: userdata.password_confirmation
        }
        if !!this.reset_password_token
          user.reset_password_token = this.reset_password_token
        else if this.$root.$current_user()
          user.current_password = userdata.current_password
        else
          user.reset_password_token = userdata.reset_token

        this.$root.axios.put('/users/password',{user: user})
          .then(
            (result) ->
              that.$root.$toast.success('Passwort geändert')
              that.$root.$login_changed()
        ).catch(
          (error) ->
            console.log error
            if !!error.data.errors
              for msg in that.$root.$errors_to_array(error.data.errors)
                that.$root.$toast.alert(msg)
            else
              that.$root.$toast.alert((error.data||'Fehler'))
        )
    }
  }

</script>

<style scoped>

</style>