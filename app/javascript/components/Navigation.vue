<template>
    <nav class='navbar navbar-default'>
        <ul class="nav navbar-nav">
            <li>
                <router-link to='/'>Home</router-link>
            </li>
            <li>
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