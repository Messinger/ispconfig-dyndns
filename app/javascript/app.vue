<template>

  <div id="app">
    <v-app id="dyndns">
        <confirm ref="confirm"></confirm>
        <spinner ref="spinner"></spinner>
        <app-navigation></app-navigation>
        <router-view></router-view>
    </v-app>
  </div>
</template>

<script lang="coffee">
    import 'regenerator-runtime/runtime'
    import Navigation from 'components/Navigation.vue'
    import confirm from 'components/shared/confirm'
    import spinneroverlay from 'components/shared/spinneroverlay'

    export default {
        components: {
            appNavigation: Navigation
            confirm: confirm
            spinner: spinneroverlay
        },
        data: () ->
          {
            message: "Töf"
          }
        ,
        mounted: () ->
            this.$root.$confirm = this.$refs.confirm.open
            this.$root.$spinner = this.$refs.spinner
    }
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
