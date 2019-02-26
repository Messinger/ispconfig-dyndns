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
              <v-text-field v-model="settings.mail_from" required :rules="emailRules"></v-text-field>
            </v-flex>
          </v-layout>
          <v-layout row wrap>
            <v-flex md1 xs3>
              <v-subheader>ISPConfig url:</v-subheader>
            </v-flex>
            <v-flex md3 xs6>
              <v-text-field v-model="settings.ispconfig_url" :rules="textRules" required></v-text-field>
            </v-flex>
          </v-layout>
          <v-layout row wrap>
            <v-flex md1 xs3>
              <v-subheader>Remote User:</v-subheader>
            </v-flex>
            <v-flex md3 xs6>
              <v-text-field v-model="settings.remote_user" :rules="textRules" required></v-text-field>
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
                            :rules="textRules"
              >
              </v-text-field>
            </v-flex>
          </v-layout>
          <v-layout row wrap>
            <v-flex md1 xs3>
              <v-subheader>Max records per User:</v-subheader>
            </v-flex>
            <v-flex md3 xs6>
              <v-text-field v-model="settings.max_records" required type="number" :rules="maxRecordsRules" min="1"></v-text-field>
            </v-flex>
          </v-layout>
          <v-layout row wrap>
            <v-flex md1 xs3>
              <v-subheader>Default TTL (sec):</v-subheader>
            </v-flex>
            <v-flex md3 xs6>
              <v-text-field v-model="settings.default_ttl" required type="number" :rules="ttlRules" min="300" max="7200"></v-text-field>
            </v-flex>
          </v-layout>
        </v-form>
      </v-card-text>
      <v-card-actions>
        <v-btn :disabled="!valid" :loading="saving" color="primary darken-1" flat="flat" @click.native="submit_settings">Einstellungen speichern</v-btn>
      </v-card-actions>
    </v-card>
  </div>
</template>

<script lang="coffee">
    export default {
        name: "app_settings"
        data: () ->
          {
            saving: false
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
            textRules: [
              (v) -> !!v || 'Required'
            ]
            ttlRules: [
              (v) -> !!v || 'Required and must be an Number'
              (v) -> !isNaN(v) || 'Must be number'
              (v) ->
                iv = parseInt(v)
                if iv < 300
                  'Must be >= 300'
                else if iv > 7200
                   'Must be <= 7200'
                else
                  true
            ]
            maxRecordsRules: [
              (v) -> !!v || 'Required and must be an Number'
              (v) -> !isNaN(v) || 'Must be number'
              (v) ->
                iv = parseInt(v)
                if iv < 1
                  'Must be >= 1'
                else
                  true
            ]
            emailRules: [
              (v) -> !!v || 'E-mail is required'
              (v) -> /.+@.+/.test(v) || 'E-mail must be valid'
            ]
          }

        mounted: () ->
          this.fetch_settings()

        methods: {
            fetch_settings: () ->
              that = this
              this.saving = true
              this.axios.get('/settings')
                .then(
                  (response) ->
                    that.saving = false
                    that.settings = response.data.settings
              ).catch((error) ->
                that.saving = false
                that.$root.$toast.error(error.data||'Fehler beim Laden der Einstellungen')
              )

            submit_settings: () ->
              return unless this.$refs.form.validate()
              that = this
              this.saving = true
              this.axios.post('/settings/edit',{settings: this.settings}).then( (response) ->
                that.$root.$toast.success('Einstellungen gespeichert')
                that.saving = false
              ).catch(
                  (error) ->
                    that.saving = false
                    that.$root.$toast.error(error.data||'Fehler')
              )
        }
    }
</script>

<style scoped>

</style>