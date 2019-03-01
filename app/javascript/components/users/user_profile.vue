<template>
  <div id="user_profile">
    <v-card>
      <v-card-title>
        <h3>Profil von {{user.name || user.email}}</h3>
      </v-card-title>
      <div v-if="!!user.name || !!user.email">
        <v-form ref="form" v-model="valid" lazy-validation id="userprofileform" @keyup.enter.native="submit_request">
          <v-layout row wrap>
            <v-flex d-flex offset-md1 xs12 sm12 md8>
              <v-card-text>
                <v-layout row>
                  <v-flex md2 xs3>
                    <v-subheader>Name:</v-subheader>
                  </v-flex>
                  <v-flex d-flex xs12 md11 child-flex>
                    <v-text-field v-model="user.name" label="Name" ></v-text-field>
                  </v-flex>
                </v-layout>
                <v-layout row>
                  <v-flex md2 xs3>
                    <v-subheader>Email:</v-subheader>
                  </v-flex>
                  <v-flex d-flex xs12 md11 child-flex>
                    <v-text-field v-model="user.email" label="Email" ></v-text-field>
                  </v-flex>
                </v-layout>
                <span v-if="!user.identity">
                <v-layout row>
                  <h3>Leer lassen, falls das Passwort nicht geändert werden soll.</h3>
                </v-layout>
                <v-layout row v-if="!user.identity">
                  <v-flex md12 xs12>
                    <password-input ref="pwform"></password-input>
                  </v-flex>
                </v-layout>
                </span>
              </v-card-text>
            </v-flex>
          </v-layout>
        </v-form>
        <v-card-actions class="pt-0">
          <v-btn :disabled="!valid" color="primary darken-1" flat="flat" @click.native="submit_request">Änderungen speichern</v-btn>
        </v-card-actions>
      </div>
    </v-card>
  </div>
</template>

<script lang="coffee">
  import clonedeep from 'lodash.clonedeep'
  import password_input from '../shared/password_input'

  export default {
    name: "user_profile"
    data: () ->
      {
        user: {}
        valid: false
      }

    components: {
      'password-input': password_input
    }

    mounted: () ->
      if !this.$root.$current_user() || this.$root.$current_user().type != 'User'
        this.$router.push({name:'home'})
      else
        this.fetch_user()

    methods: {
      fetch_user: () ->
        that = this
        this.$root.axios.get('/users/edit').then((result) ->
          that.user = clonedeep(result.data.user)
          console.log "User: ",that.user
        ).catch((error) ->
          that.user = {}
          that.$root.$toast.error(error.data||'Fehler beim Abrufen')
        )

      submit_request: () ->
        if !!this.$refs.pwform && !!this.$refs.pwform.current_password
          this.user.current_password = this.$refs.pwform.current_password
          this.user.password = this.$refs.pwform.password
          this.user.password_confirmation = this.$refs.pwform.password_confirmation
          this.$refs.pwform.current_password = null
        console.log "Submit ",this.user
        that = this
        this.$root.axios.put('/users',{user: this.user}).then((response) ->
          console.log "Update response: ", response
          that.$root.$toast.success('Profil geändert')
        ).catch((error) ->
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