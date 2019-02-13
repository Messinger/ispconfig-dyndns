<template>
    <nav class='navbar navbar-default'>
        <ul class="nav navbar-nav">
            <li>
                <router-link to='/'>Home</router-link>
            </li>
            <li v-if="loggedIn()">
                <router-link to='/dns-host-records'>Records</router-link>
            </li>
        </ul>
    </nav>
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