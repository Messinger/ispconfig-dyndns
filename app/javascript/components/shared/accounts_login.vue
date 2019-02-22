<template>
  <div id="accounts_login_container">
    <v-card>
      <v-card-title light dense flat>
        <h3>{{ title }}</h3>
      </v-card-title>
      <v-card-text>
        <div>
          <v-alert v-model="alert" dismissible type="error">
            {{alertmsg}}
          </v-alert>
        </div>
        <v-form ref="form" v-model="valid" lazy-validation id="loginform">

          <div  v-if="user_type==='client'" >
            <v-text-field v-model="client.login_id" :rules="loginRules" label="Login ID" required ></v-text-field>
            <v-text-field v-model="client.password" :rules="passwordRules" :type='password' label="Password" required></v-text-field>
          </div>

          <div  v-if="user_type==='admin'" >
            <v-text-field v-model="admin.login" :rules="loginRules" label="Login ID" required ></v-text-field>
            <v-text-field v-model="admin.password" :rules="passwordRules" :type='password' label="Password" required></v-text-field>
          </div>

          <div  v-if="user_type==='user'" >
            <v-layout row wrap>
              <v-flex d-flex xs12 sm1 md1 child-flex>
                <authproviders ref="authprovider"></authproviders>
              </v-flex>
              <v-flex d-flex>
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
        <v-btn color="grey" flat="flat" @click.native="cancel">Cancel</v-btn>
        <v-btn @click.native="signupuser" v-if="user_type==='user'" flat >Signup</v-btn>
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
      alert: false,
      alertmsg: 'Fehler beim Login',
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
                  that.alertmsg = response.data.error||'Fehler'
                  that.alert = true
                else
                  that.$root.$login_changed()
                  that.$router.push({name: 'home'})
          ).catch(
              (error) ->
                window.$cookies.remove("OAUTH-JSON-LOGIN")
                that.alert = true
                window.Constants.current_user = null;
          )
    }
  }
</script>

<style scoped>

</style>