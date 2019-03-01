<template>
  <div id="confirm_email">
    <v-card>
      <v-card-title>
        <h3>Got token: {{confirmation_token}}</h3>
      </v-card-title>
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
          this.axios.get('/users/confirmation',{ params: {confirmation_token: this.token}}
          ).then( (result) ->
            console.log "Token result: ",result.data
            that.$root.$login_changed()
          ).catch( (error) ->
            if !!error.data && !!error.data['confirmation_token']
              for msg in that.$root.$errors_to_array(error.data)
                that.$root.$toast.error(msg)
            else
              that.$root.$toast.error(error.data||'Fehler')
            that.update_user()
          )

        refresh_login_data: () ->
          console.log "Refresh logged in user"
          this.$root.$update_user()
          this.update_user()

        update_user: () ->
          that = this
          clearTimeout(this.update_timer)
          this.current_user = this.$root.$current_user()
          if !!this.current_user
            if !this.current_user.email_must_verified
              this.$router.push({name: 'home'})
            else
              this.update_timer = setTimeout(this.refresh_login_data,5000)
    }
  }
</script>

<style scoped>

</style>