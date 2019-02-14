<template>
    <v-toolbar>
        <v-toolbar-side-icon></v-toolbar-side-icon>
        <v-toolbar-title>Dyndns</v-toolbar-title>
        <v-toolbar-items class="hidden-sm-and-down">
        <v-btn flat to="/">
            Home
        </v-btn>
        <v-btn flat to="/dns-host-records" v-if="loggedIn()">
            Records
        </v-btn>
        </v-toolbar-items>
    </v-toolbar>
</template>

<script>
    export default {
        name: "Navigation",
        methods: {
            loggedIn() {
                return !(window === undefined || window.Constants === undefined || window.Constants.current_user === null);
            }
        }
    }
</script>

<style scoped>

</style>