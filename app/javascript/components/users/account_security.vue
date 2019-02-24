<template>
  <div id="account_security_div">
    <v-card>
      <v-card-title>
        <h3>{{title}} für <span class="first_upcase">{{ usertype }}</span></h3>
      </v-card-title>
      <v-card-text>
        <v-form ref="form" v-model="valid" lazy-validation id="loginform" @keyup.enter.native="submit_request">
          <v-layout row wrap>
            <v-flex d-flex  xs12 sm12 offset-md1 md10>
              <v-text-field v-model="submit.login" :rules="loginRules" label="Login ID" required v-if="inputtype=='login'"></v-text-field>
              <v-text-field v-model="submit.email" :rules="emailRules" label="Email" required v-else></v-text-field>
            </v-flex>
          </v-layout>
        </v-form>
      </v-card-text>
      <v-card-actions class="pt-0">
        <v-btn :disabled="!valid" color="primary darken-1" flat="flat" @click.native="submit_request">Anfordern</v-btn>
      </v-card-actions>
      <v-card-actions v-if="usertype!=='client'">
        <v-breadcrumbs :items="br_items">
          <v-icon slot="divider">code</v-icon>
        </v-breadcrumbs>
      </v-card-actions>
    </v-card>
  </div>
</template>

<script lang="coffee">

  export default {
    props: ['action','usertype']
    components: {}
    name: "account_security"
    data: () -> {
      valid: false
      title: ''
      targeturl: ''
      inputtype: ''
      submit: {
        email: ''
        login: ''
      }
      loginRules: [
        (v) -> !!v || 'Login-ID is required'
      ]
      emailRules: [
        (v) -> !!v || 'E-mail is required'
        (v) -> /.+@.+/.test(v) || 'E-mail must be valid'
      ]
      br_items: []
    }
    mounted: () ->
      this.validate_data()

    watch: {
      "$route": (to,from) ->
        this.validate_data()
    }

    methods: {
      validate_data: () ->
        this.submit.email = ''
        this.submit.login = ''
        this.targeturl = switch(this.usertype)
          when('admin') then '/admins/'
          when('user') then '/users/'
          else ''

        switch(this.action)
          when 'send_confirmation'
            this.title = "Neue Emailbestätigung"
            this.targeturl="#{this.targeturl}confirmation"
            this.inputtype = 'email'
          when 'send_request_password'
            this.title = "Passwort zurücksetzen"
            this.targeturl="#{this.targeturl}password"
            this.inputtype = switch(this.usertype)
              when('admin') then 'login'
              else 'email'
          when 'send_request_unlock'
            this.title = "Entsperr-Token anfordern"
            this.targeturl="#{this.targeturl}unlock"
            this.inputtype = 'email'

        switch this.usertype
          when 'user'
            this.br_items = [
              {
                text: "Neue Email-Bestätigung anfordern"
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

      submit_request: () ->
        if this.$refs.form.validate()
          console.log "Do it now"

          submitdata = {}
          submitdata[this.usertype] = {}
          submitdata[this.usertype][this.inputtype] = this.submit[this.inputtype]
          console.log "Submit ",submitdata
          that = this

          result = await this.axios.post(this.targeturl,submitdata).catch(
              (error) ->
                console.log "Fehler: ",error
                if !!error.data.errors && !!error.data.errors[that.inputtype]
                  for msg of that.$root.$errors_to_array(error.data.errors)
                    that.$root.$toast.addNotification({text:msg,color: 'alarm'})
                else
                  that.$root.$toast.addNotification({text:error.data||'Fehler',color: 'alarm'})
          )
          console.log "Ergebnis: ",result
      }
  }
</script>

<style scoped>
  .first_upcase {
    text-transform:capitalize;
  }
</style>