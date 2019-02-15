<template>
    <v-dialog v-model="dialog" :max-width="options.width" @keydown.esc="cancel" v-bind:style="{ zIndex: options.zIndex }">
        <v-card>
            <v-toolbar dark :color="options.color" dense flat>
                <v-toolbar-title class="white--text">{{ title }}</v-toolbar-title>
            </v-toolbar>
            <v-card-text>
                <v-form ref="form" v-model="valid" lazy-validation id="loginform">
                    <csrf></csrf>
                    <v-text-field v-model="user_login_id" :rules="loginRules" label="Login ID" required ></v-text-field>
                    <v-text-field v-model="user_password" :type='password' label="Password" required></v-text-field>
                </v-form>
            </v-card-text>
            <v-card-actions class="pt-0">
                <v-btn :disabled="!valid" color="primary darken-1" flat="flat" @click.native="try_login">Login</v-btn>
                <v-btn color="grey" flat="flat" @click.native="cancel">Cancel</v-btn>
            </v-card-actions>
        </v-card>
    </v-dialog>
</template>

<script>
    import CSRF from 'components/shared/csrf.vue'
    export default {
        components: {
            csrf: CSRF,
        },
        data: () => ({
            valid: true,
            dialog: false,
            title: "Login",
            login_url: '/users/sign_in',
            usertype: 'User',
            user_login_id: '',
            user_password: '',
            password: 'Password',
            loginRules: [
                v => !!v || 'Login-ID is required'
            ],
            options: {
                color: 'primary',
                width: 290,
                zIndex: 200
            }
        }),
        methods: {
            show_login(usertype) {
                this.usertype = usertype
                if(this.usertype === 'User') {
                    this.login_url = '/users/sign_in'
                } else if(this.usertype === 'Client') {
                    this.login_url = '/client/login'
                    this.title = "Login as Domain Admin"
                } else if (this.usertype === 'Admin') {
                    this.login_url = '/admins/sign_in'
                    this.title = "Login as Admin"
                } else {
                    this.login_url = null
                }
                this.dialog = true
                return new Promise((resolve, reject) => {
                    this.resolve = resolve
                    this.reject = reject
                })
            },
            try_login() {
                if (this.$refs.form.validate()) {
                    console.log("Try login")
                    this.resolve(true)
                    this.dialog = false
                } else {
                    console.log("Not valid!")
                }
            },
            cancel() {
                this.resolve(false)
                this.dialog = false
            }
        }
    }
</script>

<style scoped>

</style>