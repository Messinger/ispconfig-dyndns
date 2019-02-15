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

    export default {
        components: {
            csrf: CSRF,
            appNavigation: Navigation,
            confirm: confirm
        },
        data: () => ({
            message: "",
        }),
        mounted: function() {
            this.$root.$confirm = this.$refs.confirm.open
        }
    }
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
