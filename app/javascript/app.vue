<template>

  <div id="app">
    <v-app id="dyndns">
        <confirm ref="confirm"></confirm>
        <csrf></csrf>
        <app-navigation></app-navigation>
        <router-view></router-view>
    </v-app>
  </div>
</template>

<script>
    import 'regenerator-runtime/runtime';
    import CSRF from 'components/shared/csrf.vue'
    import Navigation from 'components/Navigation.vue'
    import confirm from 'components/shared/confirm'
    import axios from 'axios'

    axios.defaults.xsrfCookieName = "CSRF-TOKEN";
    axios.defaults.xsrfHeaderName = "X-CSRF-Token";
//    axios.defaults.withCredentials = true;

    export default {
        components: {
            csrf: CSRF,
            appNavigation: Navigation,
            confirm: confirm,
            axios: axios
        },
        data: () => ({
            message: "",
            base_http: axios.create({
                baseURL: '/',
                headers: {
                    'Accept': 'application/json'
                },
                xsrfCookieName: "CSRF-TOKEN",
                xsrfHeaderName: "X-CSRF-Token",
                withCredentials: false
            })
        }),
        mounted: function() {
            this.$root.$confirm = this.$refs.confirm.open
            this.$root.$ownhttp = this.$data.base_http
        }
    }
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
