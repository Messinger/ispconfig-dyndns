<template>
  <div id="app_settings">
    <v-card>
      <v-card-title>
        <h3>Application settings</h3>
      </v-card-title>
      <v-card-text>
        <v-form ref="form" v-model="valid" lazy-validation id="settingsform" @keyup.enter.native="submit_settings">
          <v-layout row wrap>
            <v-flex md1 xs3>
              <v-subheader>Mail from:</v-subheader>
            </v-flex>
            <v-flex md3 xs6>
              <v-text-field v-model="settings.mail_from" required></v-text-field>
            </v-flex>
          </v-layout>
          <v-layout row wrap>
            <v-flex md1 xs3>
              <v-subheader>ISPConfig url:</v-subheader>
            </v-flex>
            <v-flex md3 xs6>
              <v-text-field v-model="settings.ispconfig_url" required></v-text-field>
            </v-flex>
          </v-layout>
          <v-layout row wrap>
            <v-flex md1 xs3>
              <v-subheader>Remote User:</v-subheader>
            </v-flex>
            <v-flex md3 xs6>
              <v-text-field v-model="settings.remote_user" required></v-text-field>
            </v-flex>
          </v-layout>
          <v-layout row wrap>
            <v-flex md1 xs3>
              <v-subheader>Remote Password:</v-subheader>
            </v-flex>
            <v-flex md3 xs6>
              <v-text-field v-model="settings.remote_password"
                            :type="showpw ? 'text' : 'password'"
                            :append-icon="showpw ? 'visibility_off' : 'visibility'" required
                            @click:append="showpw=!showpw"
              >
              </v-text-field>
            </v-flex>
          </v-layout>
          <v-layout row wrap>
            <v-flex md1 xs3>
              <v-subheader>Max records per User:</v-subheader>
            </v-flex>
            <v-flex md3 xs6>
              <v-text-field v-model="settings.max_records" required type="number" min="1"></v-text-field>
            </v-flex>
          </v-layout>
          <v-layout row wrap>
            <v-flex md1 xs3>
              <v-subheader>Default TTL (sec):</v-subheader>
            </v-flex>
            <v-flex md3 xs6>
              <v-text-field v-model="settings.default_ttl" required type="number" min="300"></v-text-field>
            </v-flex>
          </v-layout>
        </v-form>
      </v-card-text>
      <v-card-actions>
        <v-btn :disabled="!valid" color="primary darken-1" flat="flat" @click.native="submit_settings">Einstellungen speichern</v-btn>
      </v-card-actions>
    </v-card>
  </div>
</template>

<script lang="coffee">
    export default {
        name: "app_settings"
        data: () ->
          {
            showpw: false
            valid: false
            settings: {
              mail_from: ''
              ispconfig_url: ''
              remote_user: ''
              remote_password: ''
              max_records: ''
              default_ttl: ''
            }
          }

        mounted: () ->
          this.fetch_settings()

        methods: {
            fetch_settings: () ->
              that = this
              this.axios.get('/settings')
                .then(
                  (response) ->
                    console.log response.data
                    that.settings = response.data.settings
              ).catch((error) ->
                console.log error
              )

            submit_settings: () ->
              that = this
              this.axios.post('/settings/edit',{settings: this.settings}).then( (response) ->
                that.$root.$toast.success('Einstellungen gespeichert')
              ).catch(
                  (error) ->
                    that.$root.$toast.error(error.data||'Fehler')
              )
        }
    }
</script>

<style scoped>

</style>