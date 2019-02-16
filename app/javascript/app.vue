<template>

  <div id="app">
    <v-app id="dyndns">
        <confirm ref="confirm"></confirm>
        <app-navigation></app-navigation>
        <router-view></router-view>
    </v-app>
  </div>
</template>

<script lang="coffee">
    import 'regenerator-runtime/runtime'
    import Navigation from 'components/Navigation.vue'
    import confirm from 'components/shared/confirm'

    export default {
        components: {
            appNavigation: Navigation
            confirm: confirm
        },
        data: () ->
          {
            message: "Töf"
          }
        ,
        mounted: () ->
            this.$root.$confirm = this.$refs.confirm.open
    }
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
