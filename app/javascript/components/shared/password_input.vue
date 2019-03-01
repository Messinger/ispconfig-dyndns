<template>
  <div id="passwordinput">

    <input v-if="!!reset_password_token" type="hidden" v-model="reset_password_token" name="reset_password_token" id="reset_password_token">

    <v-layout v-if="!reset_password_token && !$root.$current_user()" row>
      <v-flex md2 xs3>
        <v-subheader>Reset Token:</v-subheader>
      </v-flex>
      <v-flex md5 xs12 d-flex child-flex>
        <v-text-field v-model="reset_token" label="Reset Token" :rules="defaultPasswordRules" required></v-text-field>
      </v-flex>
    </v-layout>

    <v-layout v-if="!reset_password_token && $root.$current_user()" row>
      <v-flex md2 xs3>
        <v-subheader>Aktuelles Passwort:</v-subheader>
      </v-flex>
      <v-flex d-flex child-flex md5 xs12>
        <v-text-field v-model="current_password" type='password' label="Aktuelles Passwort"></v-text-field>
      </v-flex>
    </v-layout>

    <v-layout row>
      <v-flex md2 xs3>
        <v-subheader>Passwort:</v-subheader>
      </v-flex>
      <v-flex md5 xs12 d-flex child-flex>
        <v-text-field v-model="password" :rules="pwRules" type='password' label="Password" required></v-text-field>
      </v-flex>
    </v-layout>
    <v-layout row>
      <v-flex md2 xs3>
        <v-subheader>Passwort bestätigen:</v-subheader>
      </v-flex>
      <v-flex d-flex child-flex md5 xs12>
        <v-text-field v-model="password_confirmation" :rules="pwRules" type='password' label="Password wiederholen" required></v-text-field>
      </v-flex>
    </v-layout>

  </div>
</template>

<script lang="coffee">
  export default {
    data: () ->
      {
        password: null
        password_confirmation: null
        current_password: null
        reset_token: null
        valid: false
        defaultPasswordRules: [
          (v) ->
            !!v || 'Wird benötigt'
        ]
      }
    props: [ 'reset_password_token' ]
    name: "password_input"

    computed: {
        pwRules: () ->
          if !!this.$root.$current_user && !this.current_password
            []
          else
            this.defaultPasswordRules
    }


    watch: {
      current_password: 'validateFields'
    }
    mounted: () ->

    methods: {
      validateFields: () ->
        console.log "validate"

      pwmatchAckErrors: () ->
        if !!this.$root.$current_user() && !this.current_password
          this.valid = true
          return null

        if !this.password_confirmation || !this.password
          this.valid = false
          return ['Leer']
        else if this.password_confirmation != this.password
          this.valid = false
          'Passt nicht'
        else
          this.valid = true
          null
    }
  }
</script>

<style scoped>

</style>