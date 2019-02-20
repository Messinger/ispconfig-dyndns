<template>
    <div id="signup">
        <v-card>
            <v-toolbar light dense flat>
                <v-toolbar-title>Sign up</v-toolbar-title>
            </v-toolbar>
            <v-card-text>
                <v-form ref="form" v-model="valid" lazy-validation id="signupform">
                    <v-layout row wrap>
                        <v-flex d-flex xs12 sm12 md8>
                            <v-card flat>
                                <v-flex d-flex xs12 child-flex>
                                    <v-text-field v-model="userdata.name" :rules="nameRules" label="Name" required ></v-text-field>
                                </v-flex>
                                <v-flex d-flex xs12 child-flex>
                                    <v-text-field v-model="userdata.email" :rules="emailRules" label="Email" required ></v-text-field>
                                </v-flex>
                                <v-flex d-flex child-flex xs12>
                                    <v-text-field v-model="userdata.password" :rules="passwordRules" :type='password' label="Password" required></v-text-field>
                                </v-flex>
                                <v-flex d-flex child-flex xs12>
                                    <v-text-field v-model="userdata.password_ack" :rules="passwordRules" :type='password' label="Password wiederholen" required></v-text-field>
                                </v-flex>
                            </v-card>
                        </v-flex>
                        <v-flex d-flex xs12 sm6 md2 child-flex>
                            <authproviders ref="authprovider" v-on:login-changed="oauth_finished"></authproviders>
                        </v-flex>
                    </v-layout>
                </v-form>
            </v-card-text>
        </v-card>
    </div>
</template>

<script lang="coffee">
    import authproviders from '../shared/authproviders'

    export default {
        name: "sign_up"
        components: {
            authproviders: authproviders
        }
        data: () ->
            {
              userdata: {
                email: ''
                password: ''
                name: ''
                password_ack: ''
              }
              password: 'Password'
              valid: false
              nameRules: [
                  (v) ->
                      !!v || 'Name wird benötigt'
              ]
              emailRules: [
                  (v) ->
                      !!v || 'Email wird benötigt'
              ]
              passwordRules: [
                  (v) ->
                      !!v || 'Email wird benötigt'
              ]

            }
        methods: {
              sign_up: () ->
                  console.log "Signup user",this.userdata
              ,
              oauth_finished: () ->
                  this.$root.$emit('login-changed', {})
                  this.$router.push('/')
            }
    }
</script>

<style scoped>

</style>