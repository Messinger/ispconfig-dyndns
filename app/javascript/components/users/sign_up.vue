<template>
  <div id="signup">
    <v-card>
      <v-card-title light dense flat>
        <H3>Sign up</H3>
      </v-card-title>
      <v-card-text>
        <div>
          <v-alert v-model="malert" dismissible type="error">
            {{alertmsg}}
          </v-alert>
        </div>
        <v-form ref="form" v-model="valid" lazy-validation id="signupform" @keyup.enter.native="sign_up">

          <v-layout row wrap>
            <v-flex d-flex xs12 sm1 md1 child-flex>
              <authproviders ref="authprovider"></authproviders>
            </v-flex>
            <v-flex d-flex xs12 sm12 md10>
              <v-card flat>
                <v-flex d-flex xs12 child-flex>
                  <v-text-field v-model="userdata.name" :rules="nameRules" label="Name" required ></v-text-field>
                </v-flex>
                <v-flex d-flex xs12 child-flex>
                  <v-text-field v-model="userdata.email" :rules="emailRules" label="Email" required ></v-text-field>
                </v-flex>
                <v-flex d-flex child-flex xs12>
                  <v-text-field v-model="userdata.password" :rules="passwordRules" :error_messages="pwmatchAckErrors()" :type='password' label="Password" required></v-text-field>
                </v-flex>
                <v-flex d-flex child-flex xs12>
                  <v-text-field v-model="userdata.password_confirmation" :rules="passwordRules" :error_messages="pwmatchAckErrors()" :type='password' label="Password wiederholen" required></v-text-field>
                </v-flex>
              </v-card>
            </v-flex>
          </v-layout>
        </v-form>
      </v-card-text>
      <v-card-actions class="pt-0">
        <v-btn :disabled="!valid" color="primary darken-1" flat="flat" @click.native="sign_up">Sign Up</v-btn>
      </v-card-actions>
    </v-card>
  </div>
</template>

<script lang="coffee">
  import authproviders from '../shared/authproviders'

  export default {
    name: "sign_up"
    components: {
      authproviders: authproviders
    }
    data: () ->
      {
        malert: false
        alertmsg: ''
        userdata: {
          email: ''
          password: ''
          name: ''
          password_confirmation: ''
        }
        password: 'Password'
        valid: false
        nameRules: [
          (v) ->
            !!v || 'Name wird benötigt'
        ]
        emailRules: [
          (v) ->
            !!v || 'Email wird benötigt'

          (v) ->
            /.+@.+/.test(v) || 'E-mail must be valid'
        ]
        passwordRules: [
          (v) ->
            !!v || 'Password wird benötigt'
        ]
      }
    methods: {
      sign_up: () ->
        return unless (this.$refs.form.validate())
        console.log "Signup user",this.userdata
        submitvalues = {
          user: this.userdata
        }
        that = this
        this.malert = false
        this.alertmsg = ""
        result = undefined
        result = await this.axios.post('/users', submitvalues).catch( (error) ->
          console.log "Got signup error",error
          era = that.$root.$errors_to_array(error.data.errors)
          era = era.join(", ")
          that.alertmsg = era
          that.malert = true
          result = undefined
        )
        console.log "Got signup result: ",result
        unless result == undefined
          that.malert = false
          that.$router.push('/')



      oauth_finished: () ->
        this.$root.$emit('login-changed', {})
        this.$router.push('/')

      pwmatchAckErrors: () ->
        if !this.userdata.password_confirmation || !this.userdata.password
#this.alertmsg = '' #Passwort wird benötigt'
          this.alert = false
          this.valid = false
        else if this.userdata.password_confirmation != this.userdata.password
          this.alertmsg = 'Passwörter müssen identisch sein'
          this.alert = true
          this.valid = false
        else
          this.alert = false
          this.valid = true
    }
  }
</script>

<style scoped>

</style>