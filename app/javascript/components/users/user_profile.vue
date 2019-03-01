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
                  <v-flex md1 xs3>
                    <v-subheader>Name:</v-subheader>
                  </v-flex>
                  <v-flex d-flex xs12 md11 child-flex>
                    <v-text-field v-model="user.name" label="Name" ></v-text-field>
                  </v-flex>
                </v-layout>
                <v-layout row>
                  <v-flex md1 xs3>
                    <v-subheader>Email:</v-subheader>
                  </v-flex>
                  <v-flex d-flex xs12 md11 child-flex>
                    <v-text-field v-model="user.email" label="Email" ></v-text-field>
                  </v-flex>
                </v-layout>

                <v-layout row v-if="!user.identity">
                </v-layout>

              </v-card-text>
            </v-flex>
          </v-layout>
        </v-form>
      </div>
    </v-card>
  </div>
</template>

<script lang="coffee">
  import clonedeep from 'lodash.clonedeep'

  export default {
    name: "user_profile"
    data: () ->
      {
        user: {}
        valid: false
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
        console.log "Submit ",this.user
        that = this
    }
  }
</script>

<style scoped>

</style>