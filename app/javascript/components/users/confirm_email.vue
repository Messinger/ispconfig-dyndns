<template>
  <div id="confirm_email">
    <v-card>
      <v-card-title>
        <h3>Got token: {{confirmation_token}}</h3>
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
        <v-form ref="form" v-model="valid" lazy-validation id="token" @keyup.enter.native="submit_request_for_token">
          <v-layout row wrap>
            <v-flex d-flex  xs12 sm12 offset-md1 md10>
              <v-text-field v-model="token" :rules="tokenRules" label="Bestätigungs token" required></v-text-field>
            </v-flex>
          </v-layout>
        </v-form>
      </v-card-text>
      <v-card-actions>
        <v-btn :disabled="!valid" color="primary darken-1" flat="flat" @click.native="submit_request_for_token">Token abschicken</v-btn>
      </v-card-actions>
    </v-card>
  </div>
</template>

<script lang="coffee">
  export default {
    props: [ 'confirmation_token' ]
    name: "confirm_email"
    data: () ->
      {
        alert: false
        alertmsg: ''
        snacktimeout: 6000
        ontop: true

        current_user: null
        update_timer: null
        token: ''
        valid: false
        tokenRules: [
          (v) -> !!v || 'Token is required'
        ]

      }

    mounted: () ->
      this.update_user()

    methods: {
        submit_request_for_token: () ->
          that = this
          clearTimeout(this.update_timer)
          result = await this.axios.get('/users/confirmation',{ params: {confirmation_token: this.token}}).catch(
              (error) ->
                that.alert = true
                if !!error.data && !!error.data['confirmation_token']
                  that.alertmsg = that.$root.$errors_to_array(error.data)[0]
                else
                  that.alertmsg = error.data||'Fehler'
                that.update_user()
          )
          console.log result

        update_user: () ->
          that = this
          clearTimeout(this.update_timer)
          this.current_user = this.$root.$current_user()
          if !!this.current_user
            if !this.current_user.email_must_verified
              this.$router.push({name: 'home'})
            else
              this.update_timer = setTimeout(
                  () ->
                    console.log "Refresh user"
                    that.$root.$update_user()
                    that.update_user()
              ,5000)
    }
  }
</script>

<style scoped>

</style>