<template>
    <v-toolbar >
        <v-toolbar-side-icon></v-toolbar-side-icon>
        <v-toolbar-title>Dyndns</v-toolbar-title>
        <v-toolbar-items class="hidden-sm-and-down">
            <v-btn flat to="/">
                Home
            </v-btn>
            <v-btn flat to="/dns-host-records" v-if="isUser()||isClient()">
                Records
            </v-btn>
            <v-btn flat v-if="!logged_in" v-on:click="login_user">
                Login
            </v-btn>
        </v-toolbar-items>
        <v-spacer></v-spacer>
        <v-toolbar-items class="hidden-sm-and-down" v-if="logged_in">
            <v-btn flat v-on:click="logout_user()">
                Logout
            </v-btn>
        </v-toolbar-items>
        <v-toolbar-items class="hidden-sm-and-down" v-if="!logged_in">
            <v-btn flat v-on:click="login_client">
                Domain admin
            </v-btn>
            <v-btn flat v-on:click="login_admin">
                Platform admin
            </v-btn>
        </v-toolbar-items>
        <logindialog ref="logindialog" v-on:login-changed="checkLoggedIn"></logindialog>
    </v-toolbar>
</template>

<script>
    import logindialog from './shared/logindialog'
    export default {
        name: "Navigation",
        data: () => ({
            logged_in: false
        }),
        methods: {
            checkLoggedIn() {
                console.log("Current user: "+window.Constants.current_user)
                this.logged_in = this.loggedIn()
            },
            loggedIn() {
                return !(window === undefined || window.Constants === undefined || window.Constants.current_user === null);
            },
            isClient() {
                return this.loggedIn() && window.Constants.current_user.type === 'ClientUser'
            },
            isUser() {
                return this.loggedIn() && window.Constants.current_user.type === 'User'
            },
            login_admin() {
                console.log(this.$refs)
                this.$refs.logindialog.show_login('Admin').then((confirm) => {
                    console.log("Bestätigt mit: "+confirm)
                })
            },
            login_user() {
                this.$refs.logindialog.show_login('User').then((confirm) => {
                    console.log("Bestätigt mit: "+confirm)
                })
            },
            login_client() {
                console.log(this.$refs)
                this.checkLoggedIn()
                this.$refs.logindialog.show_login('Client').then((confirm) => {
                    console.log("Bestätigt mit: "+confirm)
                    console.log("Eingeloggt: "+this.loggedIn())
                })
            },
            logout_user() {
                this.$refs.logindialog.logout()
            }

        },
        components: {
            logindialog: logindialog
        },
        mounted: function () {
            this.checkLoggedIn()
        }
    }
</script>

<style scoped>

</style>