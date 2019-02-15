<template>
    <v-dialog v-model="dialog" :max-width="options.width" @keydown.esc="cancel" v-bind:style="{ zIndex: options.zIndex }">
        <v-card>
            <v-toolbar dark :color="options.color" dense flat>
                <v-toolbar-title class="white--text">{{ title }}</v-toolbar-title>
            </v-toolbar>
            <v-card-text>

                <v-form ref="form" v-model="valid" lazy-validation id="loginform">

                    <div  v-if="keyuser==='client'" >
                        <v-text-field v-model="client.login_id" :rules="loginRules" label="Login ID" required ></v-text-field>
                        <v-text-field v-model="client.password" :rules="passwordRules" :type='password' label="Password" required></v-text-field>
                    </div>

                    <div  v-if="keyuser==='admin'" >
                        <v-text-field v-model="admin.login" :rules="loginRules" label="Login ID" required ></v-text-field>
                        <v-text-field v-model="admin.password" :rules="passwordRules" :type='password' label="Password" required></v-text-field>
                    </div>

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
    import csrf from 'components/shared/csrf.vue'
    export default {
        components: {
            csrf: csrf,
        },
        data: () => ({
            valid: true,
            dialog: false,
            keyuser: 'user',
            client: {
                login_id: '',
                password: '',
            },
            admin: {
                login: '',
                password: ''
            },
            user: {
                email: '',
                password: ''
            },
            title: "Login",
            login_url: '/users/sign_in',
            usertype: 'User',
            password: 'Password',
            loginRules: [
                v => !!v || 'Login-ID is required'
            ],
            passwordRules: [
                v => !!v || 'Password is required'
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
                    this.keyuser = 'user'
                } else if(this.usertype === 'Client') {
                    this.login_url = '/client/sessions'
                    this.title = "Login as Domain Admin"
                    this.keyuser = 'client'
                } else if (this.usertype === 'Admin') {
                    this.login_url = '/admins/sign_in'
                    this.title = "Login as Admin"
                    this.keyuser = 'admin'
                } else {
                    this.login_url = null
                }
                this.dialog = true
                return new Promise((resolve, reject) => {
                    this.resolve = resolve
                    this.reject = reject
                })
            },
            try_login: function () {
                if (this.$refs.form.validate()) {
                    console.log("Try login")
                    this.resolve(true)
                    this.dialog = false
                    let submitvalues = {}

                    submitvalues[this.keyuser] = this.$data[this.keyuser]

                    this.$root.$ownhttp.post(this.login_url, submitvalues).then(response => {
                        window.Constants.current_user = response.data.account
                        this.$emit('login-changed', {})
                        this.$router.push('/')
                        this.$router.go('/')
                    }).catch(err => {
                        this.$emit('login-changed', {})
                        window.Constants.current_user = null
                    })
                } else {
                    console.log("Not valid!")
                    this.$emit('login-changed', {})
                    window.Constants.current_user = null
                }
            },
            cancel() {
                this.resolve(false)
                this.dialog = false
            },
            logout() {
                if(window.Constants.current_user === null ) {
                    return;
                }
                let logouturl = ''
                if(window.Constants.current_user.type === 'ClientUser') {
                    logouturl = '/clients/logout'
                } else if(window.Constants.current_user.type === 'User') {
                    logouturl = '/users/sign_out'
                } else if(window.Constants.current_user.type === 'Admin') {
                    logouturl = '/admins/sign_out'
                }
                if(logouturl === ''){
                    return
                }
                this.$root.$ownhttp.delete(logouturl).then(response => {
                    window.Constants.current_user = null
                    this.$emit('login-changed', {})
                    this.$router.push('/')
                    this.$router.go('/')
                }).catch(err => {
                    this.$emit('login-changed', {})
                    this.$router.push('/')
                    this.$router.go('/')
                    window.Constants.current_user = null
                })
            }
        }
    }
</script>

<style scoped>

</style>