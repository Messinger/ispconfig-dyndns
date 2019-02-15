<template>
    <v-toolbar>
        <v-toolbar-side-icon></v-toolbar-side-icon>
        <v-toolbar-title>Dyndns</v-toolbar-title>
        <v-toolbar-items class="hidden-sm-and-down">
            <v-btn flat to="/">
                Home
            </v-btn>
            <v-btn flat to="/dns-host-records" v-if="isUser()">
                Records
            </v-btn>
        </v-toolbar-items>
        <v-spacer></v-spacer>
        <v-toolbar-items class="hidden-sm-and-down" v-if="!loggedIn()">
            <v-btn flat v-on:click="login_client()">
                Domain admin
            </v-btn>
            <v-btn flat v-on:click="login_admin()">
                Platform admin
            </v-btn>
        </v-toolbar-items>
        <logindialog ref="logindialog"></logindialog>
    </v-toolbar>
</template>

<script>
    import logindialog from 'components/shared/logindialog'
    export default {
        name: "Navigation",
        methods: {
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
            login_client() {
                console.log(this.$refs)
                this.$refs.logindialog.show_login('Client').then((confirm) => {
                    console.log("Bestätigt mit: "+confirm)
                })
            }

        },
        components: {
            logindialog: logindialog
        }
    }
</script>

<style scoped>

</style>