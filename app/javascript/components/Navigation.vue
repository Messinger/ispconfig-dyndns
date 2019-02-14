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
            <v-btn flat>
                Domain admin
            </v-btn>
            <v-btn flat>
                Platform admin
            </v-btn>
        </v-toolbar-items>
    </v-toolbar>
</template>

<script>
    import loginDialog from 'components/shared/login_dialog'
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
            }
        }
    }
</script>

<style scoped>

</style>