<template>
    <nav class='navbar'>
        <ul class="navbar-nav nav">
            <li>
                <router-link to='/'>Home</router-link>
                <router-link to='/dns-host-records'>Records</router-link>
            </li>
        </ul>
    </nav>
</template>

<script>
    export default {
        name: "Navigation"
    }
</script>

<style scoped>

</style>