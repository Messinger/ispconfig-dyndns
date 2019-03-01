<template>
  <div id="passwordinput">

    <input v-if="!!reset_password_token" type="hidden" v-model="reset_password_token" name="reset_password_token" id="reset_password_token">

    <v-layout v-if="!reset_password_token && !$root.$current_user()" row>
      <v-flex md2 xs3>
        <v-subheader>Reset Token:</v-subheader>
      </v-flex>
      <v-flex md5 xs12 d-flex child-flex>
        <v-text-field v-model="reset_token" label="Reset Token" :rules="passwordRules" required></v-text-field>
      </v-flex>
    </v-layout>

    <v-layout row>
      <v-flex md2 xs3>
        <v-subheader>Passwort:</v-subheader>
      </v-flex>
      <v-flex md5 xs12 d-flex child-flex>
        <v-text-field v-model="password" :rules="passwordRules" :error_messages="pwmatchAckErrors()" type='password' label="Password" required></v-text-field>
      </v-flex>
    </v-layout>
    <v-layout row>
      <v-flex md2 xs3>
        <v-subheader>Passwort bestätigen:</v-subheader>
      </v-flex>
      <v-flex d-flex child-flex md5 xs12>
        <v-text-field v-model="password_confirmation" :rules="passwordRules" :error_messages="pwmatchAckErrors()" type='password' label="Password wiederholen" required></v-text-field>
      </v-flex>
    </v-layout>

    <v-layout v-if="!reset_password_token && $root.$current_user()" row>
      <v-flex md2 xs3>
        <v-subheader>Aktuelles Passwort:</v-subheader>
      </v-flex>
      <v-flex d-flex child-flex md5 xs12>
        <v-text-field v-model="current_password" :rules="passwordRules" type='password' label="Aktuelles Passwort" required></v-text-field>
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
        passwordRules: [
          (v) ->
            !!v || 'Wird benötigt'
        ]
      }
    props: [ 'reset_password_token' ]
    name: "password_input"
    mounted: () ->

    methods: {
      pwmatchAckErrors: () ->
        if !this.password_confirmation || !this.password
          this.valid = false
        else if this.password_confirmation != this.password
          this.valid = false
        else
          this.valid = true
    }
  }
</script>

<style scoped>

</style>