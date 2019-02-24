<template>
  <div id="finish_signup_div">
    <v-card>
      <v-card-title>
        <h3>Finish signup</h3>
      </v-card-title>
      <div>
        <v-snackbar v-model="alert" color="error" :timeout="snacktimeout" :top="ontop">
          {{alertmsg}}
          <v-btn dark flat @click="alert = false">
            <v-icon>mdi-close</v-icon>
          </v-btn>
        </v-snackbar>
      </div>
      <v-card-text>
        <v-form ref="form" v-model="valid" lazy-validation id="loginform" @keyup.enter.native="submit_request_for_token">
          <v-layout row wrap>
            <v-flex d-flex  xs12 sm12 offset-md1 md10>
              <v-text-field v-model="submit.email" :rules="emailRules" label="Email" required></v-text-field>
            </v-flex>
          </v-layout>
        </v-form>
      </v-card-text>
      <v-card-actions>
        <v-btn :disabled="!valid" color="primary darken-1" flat="flat" @click.native="submit_request_for_token">Bestätigung Anfordern</v-btn>
      </v-card-actions>
    </v-card>

  </div>
</template>

<script lang="coffee">
  export default {
    name: "finish_signup"
    props: ['id']

    data: () ->{
      valid: false
      emailRules: [
        (v) -> !!v || 'E-mail is required'
        (v) -> /.+@.+/.test(v) || 'E-mail must be valid'
      ]
      submit: {
        email: null
      }
      alert: false
      alertmsg: ''
      snacktimeout: 6000
      ontop: true
    }

    mounted: () ->
      if !this.$root.$current_user()
        this.$router.push({name: 'userlogin', params: {usertype: 'user'}})
      else if !this.$root.$current_user().email_must_verified || !!this.$root.$current_user().unconfirmed_set
        this.$router.push({name: 'home'})

    methods: {
      submit_request_for_token: () ->
        that = this
        console.log "Submit"
        submitdata = {
          user: {
            email: this.submit.email
          }
        }
        console.log "Sende für Benutzer #{this.id}: ",submitdata
        result = await this.axios.post("/profile/#{this.id}/finish_signup",submitdata).catch(
            (error) ->
              that.alert = true
              if !!error.data && !!error.data['email']
                that.alertmsg = that.$root.$errors_to_array(error.data)[0]
              else
                that.alertmsg = error.data||'Fehler'

        )
        console.log result
    }

  }
</script>

<style scoped>

</style>