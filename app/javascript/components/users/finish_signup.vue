<template>
  <div id="finish_signup_div">
    <v-card>
      <v-card-title>
        <h3>Finish signup</h3>
      </v-card-title>
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

        this.axios.post("/profile/#{this.id}/finish_signup",submitdata).then( (result) ->
          console.log "Finish signup result: ",result
          if !!result
            console.log "Tell root about"
            that.$root.$login_changed()
        ).catch ( (error) ->
          result = null
          console.log "Got an error .... ",error
          if !!error.data && !!error.data['email']
            for msg in that.$root.$errors_to_array(error.data)
              that.$root.$toast.error(msg)
          else
            that.$root.$toast.error(error.data||'Fehler')
        )
    }

  }
</script>

<style scoped>

</style>