<template>
  <div id="accounts_login_container">
    <v-card>
      <v-card-title light dense flat>
        <h3>Login als <span class="first_upcase">{{ user_type }}</span></h3>
      </v-card-title>
      <v-card-text>
        <v-form ref="form" v-model="valid" lazy-validation id="loginform" @keyup.enter.native="try_login" >

          <div  v-if="user_type==='client'" >
            <v-layout row wrap>
              <v-flex d-flex  xs12 sm12 offset-md1 md10>
                <v-card flat>
                  <v-flex d-flex xs12 child-flex>
                    <v-text-field v-model="client.login_id" :rules="loginRules" label="ISPConfig User" required ></v-text-field>
                  </v-flex>
                  <v-flex d-flex xs12 child-flex>
                    <v-text-field v-model="client.password" :rules="passwordRules" :type='password' label="Password" required></v-text-field>
                  </v-flex>
                </v-card>
              </v-flex>
            </v-layout>
          </div>

          <div  v-if="user_type==='admin'" >
            <v-layout row wrap>
            <v-flex d-flex  xs12 sm12 offset-md1 md10>
              <v-card flat>
              <v-flex d-flex xs12 child-flex>
                <v-text-field v-model="admin.login" :rules="loginRules" label="Login ID" required ></v-text-field>
              </v-flex>
              <v-flex d-flex xs12 child-flex>
                <v-text-field v-model="admin.password" :rules="passwordRules" :type='password' label="Password" required></v-text-field>
              </v-flex>
              </v-card>
            </v-flex>
            </v-layout>
          </div>

          <div  v-if="user_type==='user'" >
            <v-layout row wrap>
              <v-flex d-flex xs12 sm1 md1 child-flex>
                <authproviders ref="authprovider"></authproviders>
              </v-flex>
              <v-flex d-flex  xs12 sm12 md10>
                <v-card flat>
                  <v-flex d-flex xs12 child-flex>
                    <v-text-field v-model="user.email" :rules="emailRules" label="Email" required ></v-text-field>
                  </v-flex>
                  <v-flex d-flex child-flex xs12>
                    <v-text-field v-model="user.password" :rules="passwordRules" :type='password' label="Password" required></v-text-field>
                  </v-flex>
                  <v-flex d-flex child-flex xs12>
                    <v-checkbox v-model="user.remember_me" label="Remember me"></v-checkbox>
                  </v-flex>
                </v-card>
              </v-flex>
            </v-layout>
          </div>

        </v-form>

      </v-card-text>
      <v-card-actions class="pt-0">
        <v-btn :disabled="!valid" color="primary darken-1" flat="flat" @click.native="try_login">Login</v-btn>
        <v-btn @click.native="signupuser" v-if="user_type==='user'" flat >Signup</v-btn>
      </v-card-actions>
      <v-card-actions class="pt-0" v-if="user_type!=='client'">
        <v-breadcrumbs :items="br_items">
          <v-icon slot="divider">code</v-icon>
        </v-breadcrumbs>
      </v-card-actions>
    </v-card>
  </div>
</template>

<script lang="coffee">
  import authproviders from './authproviders'
  import SignUp from '../users/sign_up'

  export default {
    name: "accounts_login"
    props: [ 'usertype' ]
    components: {
      authproviders: authproviders
      signup: SignUp
    }

    data: () -> {
      'user_type': ''
      'login_url': ''
      valid: false
      client: {
        login_id: '',
        password: '',
      },
      admin: {
        login: '',
        password: ''
      },
      user: {
        email: '',
        password: '',
        remember_me: false
      },
      br_items: []
      title: "Login",
      login_url: '/users/sign_in',
      password: 'Password',
      loginRules: [
        (v) -> !!v || 'Login-ID is required'
      ],
      passwordRules: [
        (v) -> !!v || 'Password is required'
      ],
      emailRules: [
        (v) -> !!v || 'E-mail is required'
        (v) -> /.+@.+/.test(v) || 'E-mail must be valid'
      ],
      options: {
        color: 'white',
        width: 600,
        zIndex: 200
      }
    }

    mounted: () ->
      this.validate_data()

    watch: {
        "$route": (to,from) ->
          this.validate_data()
    }

    methods: {
        validate_data: () ->
          this.user_type = this.usertype.toLowerCase()
          this.login_url = switch(this.user_type)
            when ('user') then '/users/sign_in'
            when ('client') then '/client/sessions'
            when ('admin') then '/admins/sign_in'
            else nil

          this.title = "Login als #{this.user_type}"

          switch this.user_type
            when 'user'
              this.br_items = [
                {
                  text: "Bestätigung anfordern"
                  disabled: false
                  to: {name: 'send_confirmation'}
                },
                {
                  text: "Passwort vergessen?"
                  disabled: false
                  to: {name: 'request_password'}
                },
                {
                  text: "Login gesperrt?"
                  disabled: false
                  to: {name: 'request_unlock'}
                }
              ]
            when 'admin'
              this.br_items = [
                {
                  text: "Passwort vergessen?"
                  disabled: false
                  to: {name: 'admin_request_password'}
                },
                {
                  text: "Login gesperrt?"
                  disabled: false
                  to: {name: 'admin_request_unlock'}
                }
              ]
            else
              this.br_items = []

      signupuser: () ->
        that = this
        setTimeout(
            () ->
              that.$router.push({name: 'user_signup'});
          ,10
        )

      try_login: () ->
        if this.$refs.form.validate()
          submitvalues = {}
          that = this
          submitvalues[this.user_type] = this.$data[this.user_type]
          window.$cookies.set("OAUTH-JSON-LOGIN",'1')
          this.axios.post(this.login_url, submitvalues).then(
              (response) ->
                window.$cookies.remove("OAUTH-JSON-LOGIN")
                window.Constants.current_user = response.data.account||null
                console.log "Resonse: ",response
                if response.status > 399
                  that.$root.$toast.addNotification({text:response.data.error||'Fehler',color: 'alarm'})
                else
                  that.$root.$login_changed()
                  that.$router.push({name: 'home'})
          ).catch(
              (error) ->
                window.$cookies.remove("OAUTH-JSON-LOGIN")
                that.$root.$toast.alert(error.data.error||'Fehler')
                window.Constants.current_user = null;
          )
    }
  }
</script>

<style scoped>

  .first_upcase {
    text-transform:capitalize;
  }

</style>